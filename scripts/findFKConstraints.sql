/************************************************************
		Author: Jeffrey Sciamanna
        Creation Date: 12-09-2014

        Description:
		Script to find foreign key constraints
		on a table and generate statements to 
		turn them on or off
************************************************************/
DECLARE @TABLENAME VARCHAR(20),
        @constraintStatus INT,
        @onOff VARCHAR(50),
        @select VARCHAR(MAX),
	@title VARCHAR(20),
        @PRINT INT;

SET @TABLENAME = ''; -- Table name you're looking at
SET @constraintStatus = 0; -- To be safe let's generate on statements by default
SET @PRINT = 0; -- By default we don't print. Use it if you wanna see the statements being run

IF (@constraintStatus = 0)
	BEGIN
	        SET @onOff = 'NOCHECK CONSTRAINT ALL';
		SET @title = 'CONSTRAINTS_OFF';
	END

ELSE IF (@constraintStatus = 1)
	BEGIN
       		SET @onOff = 'WITH CHECK CHECK CONSTRAINT ALL';
		SET @title = 'CONSTRAINTS_ON';
	END

--GENERATE SQL STATEMENTS TO TURN CONSTRAINTS ON/OFF
SET @select = 'SELECT ''ALTER TABLE '' + OBJECT_SCHEMA_NAME(parent_object_id) + ''.['' + OBJECT_NAME(parent_object_id) +''] ' + @onOff + ''' AS ''' + @title + ''' FROM sys.foreign_keys WHERE referenced_object_id = object_id('''+ @TABLENAME +''')';

IF (@PRINT = 1) -- Printing is turned on.
BEGIN
        PRINT(@onOff);
        PRINT(@select);
END

EXEC(@select);
