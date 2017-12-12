CREATE SCHEMA dbms1;
SET SEARCH_PATH to dbms1;

-- Users table to maintain the data of all the users and authorities
CREATE TABLE Users (
  user_id decimal(9, 0),
  name varchar(20) NOT NULL,
  PRIMARY KEY (user_id)
);

-- Object table to maintain the available stock inventory
CREATE TABLE Object (
  company varchar(15),
  model_no varchar(10),
  model_name varchar(20) NOT NULL,
  type varchar(15),
  privileged boolean DEFAULT false,
  stock decimal(5, 0) DEFAULT 0,
  damaged_stock decimal(5,0) DEFAULT 0,
  PRIMARY KEY (company, model_no),
  CONSTRAINT stock_check CHECK(stock >= 0),
  CONSTRAINT damaged_stock_check CHECK(damaged_stock >= 0)
);

-- Sport_details table to store the details of the sports of the institute
CREATE TABLE Sport_Details(
  sport varchar(15),
  gender char(1),
  PRIMARY KEY (sport, gender)
);

-- Team table to maintain the data about various teams of various sports along with their captains
CREATE TABLE Team(
  sport varchar(15),
  gender char(1),
  captain_id decimal(9, 0),
  date_from date,
  date_to date,
  PRIMARY KEY (sport, gender, date_from),
  FOREIGN KEY (captain_id) REFERENCES Users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (sport, gender) REFERENCES Sport_Details(sport, gender)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT date_check CHECK(date_to IS NULL OR date_from <= date_to)
);

-- Requests table to maintain requests made by the users
CREATE TABLE Requests(
  request_no SERIAL,
  user_id decimal(9, 0) NOT NULL,
  company varchar(15) NOT NULL,
  model_no varchar(10) NOT NULL,
  request_date date NOT NULL,
  quantity decimal(4, 0) NOT NULL,
  sport varchar(15),
  gender char(1),
  PRIMARY KEY (request_no),
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (company, model_no) REFERENCES Object(company, model_no),
  FOREIGN KEY (sport, gender) REFERENCES Sport_Details(sport, gender)
);

-- Authority table to maintain the information about the authorities that are authorized to issue objects
CREATE TABLE Authority(
  authority_id decimal(9, 0),
  date_from date NOT NULL,
  date_to date,
  PRIMARY KEY (authority_id),
  CONSTRAINT auth_date_check CHECK(date_to IS NULL OR date_from <= date_to)
);

-- Issues table to maintain the issues made by the authorities
CREATE TABLE Issues(
  issue_no SERIAL,
  request_no integer,
  issue_date date NOT NULL,
  due_date date NOT NULL,
  authority_id decimal(9, 0) NOT NULL,
  quantity_issued decimal(4, 0) NOT NULL,

  PRIMARY KEY (issue_no),
  FOREIGN KEY (request_no) REFERENCES Requests(request_no),
  FOREIGN KEY (authority_id) REFERENCES Authority(authority_id),
  CONSTRAINT date_check CHECK(issue_date <= due_date),
  CONSTRAINT qty_issued_check CHECK(quantity_issued > 0)
);

-- Returns_object table to maintain the objects returned by the users
CREATE TABLE Returns_Object(
  return_no SERIAL,
  request_no integer NOT NULL,
  return_date date NOT NULL,
  authority_id decimal(9, 0) NOT NULL,
  quantity_damaged decimal(4, 0) NOT NULL,
  quantity_returned decimal(4, 0) NOT NULL,
  PRIMARY KEY (return_no),
  FOREIGN KEY (request_no) REFERENCES Requests(request_no),
  FOREIGN KEY (authority_id) REFERENCES Authority(authority_id),
  CONSTRAINT qty_returned_check CHECK(quantity_returned >= 0),
  CONSTRAINT qty_damaged_check CHECK(quantity_damaged >= 0)
);

-- SportsCommittee table to maintain the data of the Sports Committee members (Current members will have "date_to" attribute NULL
CREATE TABLE SportsCommittee(
  user_id decimal(9, 0),
  date_from date NOT NULL,
  date_to date,
  PRIMARY KEY (user_id, date_from),
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  CONSTRAINT date_check CHECK(date_to IS NULL OR date_from <= date_to)
);

-- Buys table maintains the data of objects bought by the Sports COmmittee
CREATE TABLE Buys(
  invoice_no varchar(10),
  vendor_name varchar(10),
  user_id decimal(9, 0) NOT NULL,
  company varchar(15) NOT NULL,
  model_no varchar(10) NOT NULL,
  model_name varchar(20) NOT NULL,
  quantity_bought decimal(3, 0) NOT NULL,
  buy_date date NOT NULL,
  cost decimal(6, 0) NOT NULL,
  PRIMARY KEY (invoice_no, vendor_name),
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (company, model_no) REFERENCES Object(company, model_no),
  CONSTRAINT qty_bought_check CHECK(quantity_bought > 0 AND cost > 0)
);

-- Stored procedure to implement following constraint in Issue relation
-- Issuing authority is valid
CREATE OR REPLACE FUNCTION valid_authority_check(auth_id decimal(9,0), issue_date date) RETURNS BOOL AS $$
	DECLARE
    	date_from_authority date;
        date_to_authority date;
    BEGIN
    	SELECT date_from FROM Authority WHERE authority.authority_id = auth_id INTO date_from_authority;
        SELECT date_to FROM Authority WHERE authority.authority_id = auth_id INTO date_to_authority;

        IF date_from_authority <= issue_date AND date_to_authority is NULL THEN
        	RETURN TRUE;
        END IF;
        RETURN FALSE;
	END $$ LANGUAGE 'plpgsql';

-- Stored procedure to implement following constraint in Issue relation
-- Quantity issued is always less than or equal to stock available
CREATE OR REPLACE FUNCTION valid_issue_check(qty_issued decimal(4, 0), req_no decimal(6, 0)) RETURNS BOOL AS $$
	DECLARE
  		qty_requested decimal(4, 0);
        stk decimal(5, 0);
        cmpny varchar(15);
        mno varchar(10);
    BEGIN
    	SELECT quantity FROM Requests WHERE Requests.request_no = req_no INTO qty_requested;
        SELECT company FROM Requests WHERE Requests.request_no = req_no INTO cmpny;
        SELECT model_no FROM Requests WHERE Requests.request_no = req_no INTO mno;

        SELECT stock FROM Object where Object.company = cmpny AND Object.model_no = mno INTO stk;
        IF qty_issued <= qty_requested AND qty_issued <= stk THEN
        	-- update stock of object from here
            UPDATE Object SET stock = stock - qty_issued WHERE Object.company = cmpny AND Object.model_no = mno;
        	return true;
        END IF;
        return false;

    END $$ LANGUAGE 'plpgsql';

-- DBMS Lab, Stored Procedure for SportsCommittee check
CREATE OR REPLACE FUNCTION valid_member_check(member_id decimal(9, 0), purchase_date date)
RETURNS BOOL AS $$
	DECLARE
    	committee_member SportsCommittee%rowtype;
    BEGIN

t        FOR committee_member IN select * from SportsCommittee where user_id = member_id
        LOOP
         	IF committee_member.date_from <= purchase_date AND committee_member.date_to is null THEN
        		return true;
        	END IF;
        END LOOP;
        return false;

    END $$ LANGUAGE 'plpgsql';

alter table Issues add constraint valid_authority CHECK(valid_authority_check(authority_id, issue_date));
alter table Issues add constraint valid_issue CHECK(valid_issue_check(quantity_issued, request_no));
alter table Returns_Object add constraint valid_authority CHECK(valid_authority_check(authority_id, return_date));
alter table Buys add constraint valid_member CHECK(valid_member_check(user_id, buy_date));
-- Add trigger for Returns_Object
-- Insert operation in Returns_Object implies, add stock
-- Delete operation in Returns_Object implies, remove stock which you added by mistake
-- Update operation in Returns_Object implies, we entered wrong stock first, so update stock as stock + (old - new)(-1) Because adding in stock
CREATE OR REPLACE FUNCTION procedure_item_stock() RETURNS TRIGGER AS $BODY$
	DECLARE
    	req_no decimal(6, 0);
    	cmpny varchar(15);
      	mno varchar(10);
	BEGIN

		IF (TG_OP = 'DELETE') THEN
            SELECT request_no FROM Returns_Object WHERE Returns_Object.return_no = OLD.return_no into req_no;
            select company from Requests WHERE Requests.request_no = req_no into cmpny;
            select model_no from Requests WHERE Requests.request_no = req_no into mno;
			UPDATE Object SET stock = stock - OLD.quantity_returned WHERE Object.company = cmpny AND Object.model_no = mno;
            UPDATE Object SET damaged_stock = damaged_stock - OLD.quantity_damaged WHERE Object.company = cmpny AND Object.model_no - mno;
		ELSIF (TG_OP = 'UPDATE') THEN
            SELECT request_no FROM Returns_Object WHERE Returns_Object.return_no = OLD.return_no into req_no;
            select company from Requests WHERE Requests.request_no = req_no into cmpny;
            select model_no from Requests WHERE Requests.request_no = req_no into mno;
			UPDATE Object SET Stock = Stock + NEW.quantity_returned - OLD.quantity_returned WHERE Object.company = cmpny AND Object.model_no = mno;
            UPDATE Object SET damaged_stock = damaged_stock + NEW.quantity_damaged - OLD.quantity_damaged WHERE Object.company = cmpny AND Object.model_no = mno;
            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
            SELECT request_no FROM Returns_Object WHERE Returns_Object.return_no = NEW.return_no into req_no;
            select company from Requests WHERE Requests.request_no = req_no into cmpny;
            select model_no from Requests WHERE Requests.request_no = req_no into mno;
			UPDATE Object SET stock = stock + NEW.quantity_returned WHERE Object.company = cmpny AND Object.model_no = mno;
			UPDATE Object SET damaged_stock = damaged_stock + NEW.quantity_damaged WHERE Object.company = cmpny AND Object.model_no = mno;
            RETURN NEW;
        END IF;
    	RETURN NULL;
  END $BODY$ LANGUAGE 'plpgsql';

CREATE TRIGGER object_stock AFTER INSERT OR UPDATE OR DELETE ON Returns_Object FOR EACH ROW EXECUTE PROCEDURE procedure_item_stock();

-- Add BEFORE trigger for Buys
-- Insert operation in Returns_Object implies, add stock
-- Delete operation in Returns_Object implies, remove stock which you added by mistake
-- Update operation in Returns_Object implies, we entered wrong stock first, so update stock as stock + (old - new)(-1) Because adding in stock
CREATE FUNCTION obj_update_before_buy() RETURNS TRIGGER AS $BODY$
	DECLARE
    	cmpny varchar(15);
        mno varchar(10);
    BEGIN
    	IF(TG_OP = 'INSERT') THEN
        	SELECT company from Object where company = NEW.company into cmpny;
            SELECT model_no from Object where model_no = NEW.model_no into mno;
            IF cmpny is NULL OR mno is NULL then
            	insert into object values(NEW.company, NEW.model_no, NEW.model_name, NULL, false, NEW.quantity_bought);
            else
            	update object set stock = stock + NEW.quantity_bought where company = cmpny and model_no = mno;
            end if;
            return NEW;
        elsif (TG_OP = 'UPDATE') THEN
        		update object set stock = stock + NEW.quantity_bought - OLD.qunatity_bought where company_name = cmpny and model_no = mno;
                return NEW;
        elsif (TG_OP = 'DELETE') THEN
        		update object set stock = stock - OLD.qunatity_bought where company = cmpny and model_no = mno;
    	end if;
        return NEW;
  END $BODY$ LANGUAGE 'plpgsql';

CREATE TRIGGER object_new BEFORE INSERT OR UPDATE ON Buys FOR EACH ROW EXECUTE PROCEDURE obj_update_before_buy();

CREATE TYPE get_not_returned_type AS (
	request_no integer,
	quantity_issued integer,
	quantity_returned_undamaged integer,
	quantity_damaged integer
);

CREATE OR REPLACE FUNCTION get_not_returned() RETURNS SETOF get_not_returned_type AS
$$
DECLARE
  returnrec get_not_returned_type;
  request_row Requests%ROWTYPE;
  icount integer;
  rcount integer;
  dcount integer;
BEGIN
  FOR request_row IN SELECT * FROM REQUESTS
  LOOP
    icount := 0;SELECT * from Object where damaged_stock > 0;

    rcount := 0;
    dcount := 0;

    SELECT CAST(sum(quantity_issued) AS integer) INTO icount FROM Issues WHERE request_no = request_row.request_no;
    SELECT CAST(sum(quantity_returned) AS integer) INTO rcount FROM Returns_Object WHERE request_no = request_row.request_no;
    SELECT CAST(sum(quantity_damaged) AS integer) INTO dcount FROM Returns_Object WHERE request_no = request_row.request_no;

    IF rcount+dcount < icount THEN
      returnrec.request_no = request_row.request_no;
      returnrec.quantity_issued = icount;SELECT * from Object where damaged_stock > 0;

      returnrec.quantity_returned_undamaged = rcount;
      returnrec.quantity_damaged = dcount;
      RETURN NEXT returnrec;
    END IF;

  END LOOP;
  RETURN;
END
$$ LANGUAGE 'plpgsql';
