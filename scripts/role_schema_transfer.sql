/**************************************************************
	Author: Jeffrey Sciamanna
        Creation Date: 05-19-2016
        Description:
		Transfer ownership of a schema or database
		role to another user
**************************************************************/
--
--Get Orphaned Users
--
EXEC sys.sp_change_users_login 'report';
--
--Get information about schema owner
--
SELECT * FROM information_schema.schemata WHERE schema_owner = '';

--
--Transfer ownership of a Database role
--
	USE []; -- DATABASE NAME
	GO
	ALTER AUTHORIZATION ON ROLE::[] TO [];
	GO

--
--Transfer ownership of a Schema
--
	USE []; -- DATABASE NAME
	GO
	ALTER AUTHORIZATION ON SCHEMA::[] TO [];
	GO
