-- Insert data into Users table
-- Students
insert into Users values (201501001, 'John Doe');
insert into Users values (201501002, 'Tommy Atkins');
insert into Users values (201501003, 'Joe Bloggs');
insert into Users values (201501004, 'Israel Israeli');
insert into Users values (201501005, 'Average Joe');
insert into Users values (201501006, 'Rudolf Lingens');
insert into Users values (201501007, 'John Public');
insert into Users values (201501008, 'Joe Shmoe');
insert into Users values (201501009, 'Tom');
insert into Users values (201501010, 'Dick');
insert into Users values (201501011, 'Harry');
insert into Users values (201501012, 'Mr.X');
insert into Users values (201501013, 'Blackacre');
insert into Users values (201501014, 'Nomen Nescio');
insert into Users values (201501015, 'John Dee');
insert into Users values (201501016, 'Nicholas Flamel');
insert into Users values (201501017, 'Perenelle Flamel');
insert into Users values (201501018, 'Neville Longbottom');
insert into Users values (201501019, 'Carter Kane');
insert into Users values (201501020, 'Magnus Chase');
insert into Users values (201501021, 'Annabeth Chase');
insert into Users values (201501022, 'Piper McClean');
insert into Users values (201501023, 'Hazel Levesque');
insert into Users values (201501024, 'Reyna Ramirez');
insert into Users values (201501025, 'Rachel Dare');
insert into Users values (201501026, 'Percy Jackson');
insert into Users values (201501027, 'Leo Valdez');
insert into Users values (201501028, 'Jason Grace');
insert into Users values (201501029, 'Thalia Grace');
insert into Users values (201501030, 'Nico diAngelo');
insert into Users values (201501031, 'Bianca diAngelo');
insert into Users values (201501032, 'Frank Zhang');
insert into Users values (201501033, 'Charles Beckendorf');
insert into Users values (201501034, 'Will Solace');
insert into Users values (201501035, 'Harry Potter');
insert into Users values (201501036, 'Ron Weasely');
insert into Users values (201501037, 'Hermione Granger');
insert into Users values (201501038, 'Albus Dumbeldore');
insert into Users values (201501039, 'Stephanie Edgley');
insert into Users values (201501040, 'Artemis Fowl');
-- Authorities
insert into Users values (201000401, 'ABC XYZ');
insert into Users values (201000402, 'MNO PQR');
insert into Users values (201000403, 'QWE RTY');

--Insert data into Sports Details table
insert into Sport_Details values ('Football','M');
insert into Sport_Details values ('Football','F');
insert into Sport_Details values ('Basketball','M');
insert into Sport_Details values ('Basketball','F');
insert into Sport_Details values ('Volleyball','M');
insert into Sport_Details values ('Volleyball','F');

--Insert data into Team table
insert into Team values ('Volleyball', 'M', '201501001','05-01-2015');
insert into Team values ('Volleyball', 'F', '201501003','01-05-2015');
insert into Team values ('Basketball', 'M', '201501007','12-15-2015');
insert into Team values ('Basketball', 'F', '201501011','10-21-2015');
insert into Team values ('Football', 'M', '201501016','11-01-2015');
insert into Team values ('Football', 'F', '201501012','06-01-2015');
insert into Team values ('Football','M','201501033','06-01-2015','06-02-2015');

-- Insert data into Authority table
insert into authority values (201000401, '01-27-2014', '02-03-2015');
insert into authority values (201000402, '01-10-2014');
insert into authority values (201000403, '03-12-2015');

-- Insert data into Sports Committee table
insert into sportscommittee values(201501001, '05-12-2015');
insert into sportscommittee values(201501011, '03-10-2015');
insert into sportscommittee values(201501015, '01-17-2015');
insert into sportscommittee values(201501019, '03-21-2015');
insert into sportscommittee values(201501038, '05-12-2015', '01-03-2017');
insert into sportscommittee values(201501021, '03-10-2015', '09-04-2016');
insert into sportscommittee values(201501035, '01-17-2015', '08-05-2017');
insert into sportscommittee values(201501026, '03-21-2015', '07-06-2017');

-- Insert data into Object table
insert into object values ('Adidas', 'F123', 'Football 123', 'Football', false, 40);
insert into object values ('Adidas', 'B110', 'Basketball 110', 'Basketball', false, 40);
insert into object values ('Nike', 'V010', 'Volleyball 010', 'Volleyball', false, 40);

-- Insert data into Buys table
insert into buys values (1,'WER',201501001,'Adidas', 	'F123',	'Football 123'	,	11, '01-01-2016', 9000);
insert into buys values (2,'WER',201501001,'Adidas', 	'B110',	'Basketball 110', 6, 	'01-01-2016', 4500);
insert into buys values (3,'ASD',201501011,'Nike',		'F100', 'Football 100', 	7, 	'03-11-2016', 6000);
insert into buys values (4,'QAZ',201501015,'Nike', 		'V010', 'Volleyball 010', 10, '05-21-2016', 6120);
insert into buys values (5,'QAZ',201501019,'Slazenger', 'V456', 'Volleyball 456', 2, '07-23-2016', 2000);
insert into buys values (6,'QAZ',201501019,'Slazenger', 'V456', 'Volleyball 456', 2, '07-23-2016', 2000);

insert into buys values (7,'XYZ',201501019,'Slaz', 'X455', 'Golfball 452', 2, '07-23-2017', 4000);

-- Insert data into Requests table
insert into requests values(1, 201501002, 'Adidas', 'F123', '11-07-2017', 11);
insert into requests values(2, 201501012, 'Adidas', 'B110', '10-06-2017', 2);
insert into requests values(3, 201501021, 'Nike', 'F100', '05-21-2017', 1);
insert into requests values(4, 201501009, 'Slazenger', 'V456', '01-08-2017', 3);
insert into requests values(5, 201501030, 'Nike', 'V010', '09-24-2017', 7);
insert into requests values(6, 201501027, 'Nike', 'V010', '09-23-2017', 7, 'Volleyball','F');
insert into requests values(7, 201501002, 'Adidas', 'F123', '12-08-2017', 1);

-- Insert data into Issues table
insert into issues values(1, 1, '11-08-2017', '01-01-2018', 201000402, 6);
insert into issues values(2, 4, '01-11-2017', '02-11-2017', 201000402, 1);
insert into issues values(3, 2, '10-06-2017', '11-10-2017', 201000403, 1);

-- Insert data into Returns Object table
insert into returns_object values(1, 1, '12-08-2017', 201000402, 0, 3);
insert into returns_object values(2, 4, '11-08-2017', 201000403, 1, 0);

-- Select queries to check the data of all tables
select * from Users;
select * from object;
select * from authority;
select * from requests;
select * from issues;
select * from returns_object;
select * from object;
