#include <stdio.h>
#include <string.h>
#include<sys/types.h>
#include <sqlda.h>
#include "libpq-fe.h"
#include "libpq/libpq-fs.h"

// List name of all the sports committee members
// List all the sports goods
// List all the authorities
void listAuthorities(){
	EXEC SQL BEGIN DECLARE SECTION;
  	int id;
  	char name[20];
  	int date;
  EXEC SQL END DECLARE SECTION;

  EXEC SQL DECLARE pointer CURSOR FOR
    SELECT authority_id, Name, date_to
    FROM Authority;

  EXEC SQL OPEN pointer;
  while(1){
  	EXCE SQL FETCH IN pointer INTO :id, :name, :date;
    if(NOT FOUND)
      break;
    if(date == NULL)
    	printf("Name:%s ID:%d\n", name, id);

  }
}

void listCommitteeMembers(){

}

//***************Amarnath Typing from here********************************************

void listSports() {
	EXEC SQL BEGIN DECLARE SECTION;

  EXEC SQL END DECLARE SECTION;

}

//***************Amarnath not typing from here****************************************


/* ----- Mihir's code starts here ----- */
void listStockAvailableOfAllItems() {
	/*
	 Objects that are regiseterd in the inventory (Stock may or may not be zero)
	*/
	EXEC SQL BEGIN DECLARE SECTION;
		char company_name[10];
		char model_name[20];
		int stock;
	EXEC SQL END DECLARE SECTION;
	// Declaring cursor for a query
	EXEC SQL DECLARE object_cursor CURSOR FOR
		SELECT company, model_name, stock
		FROM Object;
	// Opening cursor
	EXEC SQL OPEN object_cursor;
	// Iterating through cursor
	printf("Company name\tModel name\tStock Available\n");
	while(1) {
		EXEC SQL FETCH NEXT FROM object_cursor
			INTO :company_name, :model_name, :stock;
		printf("%s\t%s\t%d", company_name, model_name, stock);
	}
}

/*
	@Parameters
	1. char* cmpny: char[15] array, company of object
	2. char* mno: char[10], model number of object
*/
void listStockOfParticularItem(char* cmpny, char* mno)
{
	EXEC SQL BEGIN DECLARE SECTION;
		char model_name[20];
		char cmpny_name[15];
		char modelno[10];
		int stock;
	EXEC SQL END DECLARE SECTION;
	cmpny_name[0] = '\0'; modelno[0] = '\0';

	strcpy(cmpny_name, cmpny);
	strcpy(modelno, mno);

	EXEC SQL
		SELECT model_name INTO :model_name
		FROM Object
		WHERE company = :cmpny_name AND model_no = :modelno;

	EXEC SQL
		SELECT stock INTO :stock
		FROM Object
		WHERE company = :cmpny_name AND model_no = :modelno;

	if(model_name == NULL) {
		printf("No such object found in inventory with company name %s and model number %s\n", cmpny, mno);
		return;
	}
	printf("Company:%s Model name:%s Stock:%d\n", cmpny, model_name, stock);
}
/* ----- Mihir's code ends here ----- */


void ExecuteQuery(SQL_String) {
//Executes SELECT type of sql statement and displays
//returned rows one row on a line on "stdout" if no error,
//otherwise displays error details */
  printf("----------List of authorities from whom items can be issued-------\n");
  listAuthorities();
  printf("----------Members of the sports committee ------------------------\n");
  listCommitteeMembers();
}
void ExecuteUpdate(SQL_String) {
//Executes INSERT/UPDATE/DELETE type of sql statement
//and displays "successful" on stdout if no error,
//otherwise displays error details.
}
int main() {
/*
Does following tasks:
1. test ExecuteQuery and ExecuteUpdate for few of your
sample queries.
2. Add couple of rows in one of the table using
"Prepared Statement"
*/
  EXEC SQL CONNECT TO USER_NAME@IP USER_NAME USING password; // IP and USER name.
  EXEC SQL set search_path to schema_name; // Schema name .
  while(1){
    int choice = 0;
    printf("1. To execute a specific qeuery from a predefined list of queries.\n");
    printf("2. To update a specific table.\n");
    scanf("%d\n", &choice);
    if (choice == 1){
      ExecuteQuery();
    }
    else if(choice == 2){
    	ExecuteUpdate();
    }
    else{
      printf("Enter a valid choice.\n");
  }
	return 0;
}
