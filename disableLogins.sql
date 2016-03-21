BEGIN TRAN
/***********************************************************************
	Author: Jeffrey Sciamanna
	Creation Date: 03-15-2016	

	Description:
	SQL Script to enable/disable logins of 
	non-admin users to your server

	USAGE:
		@accountStatus:  1 -- enabled (DEFAULT)
				 0 -- disabled

		@test:	1 -- will rollback changes (DEFAULT)
			0 -- will commit changes

		@admins: list of those who need their account logins to
				remain active to clean up the spill

		@PRINT: 1 -- Will show statements being executed
			0 -- will not print anything (DEFAULT)
***********************************************************************/
	DECLARE @accounts AS TABLE (login_name NVARCHAR(168), [disabled] INT);
	DECLARE	@accountStatus INT, 
			@test INT, 
			@PRINT INT,
			@loginName NVARCHAR(168),
			@status VARCHAR(10), 
			@alter VARCHAR(250),
			@exclude VARCHAR(MAX),
			@select VARCHAR(MAX);

	/*#########################################################
				SET VALUES HERE
	#########################################################*/
		--EDIT THIS STRING TO ADD/REMOVE ADMINS (FULL ACCOUNT NAME REQUIRED)
		SET @exclude =  '''sa'''; -- SA is here by default, this account shouldnt be disabled ever 
					  -- account name(s) must be enclosed in '' for each name (i.e. @exclude = ''Scooter', 'America'')
		SET @accountStatus = 1;
		SET @test = 1;
		SET @PRINT = 0;
	/*#########################################################*/


/*====================================================================================
		YOU SHOULD NOT HAVE TO EDIT STATEMENTS INSIDE THIS BLOCK
====================================================================================*/
	SET @select = ' SELECT name, is_disabled
			FROM sys.server_principals
			WHERE [TYPE] IN (''U'', ''S'', ''G'')
			AND name NOT IN ('+@exclude+')';	

	IF (@accountStatus = 0)
		SET @status = 'DISABLE';
	ELSE IF (@accountStatus = 1)
		SET @status = 'ENABLE';

	INSERT INTO @accounts
	EXEC(@select);

	-- Loop through and disable each appropriate account
	WHILE (SELECT COUNT(*) FROM @accounts) > 0
	BEGIN
			SET @loginName = (SELECT TOP 1 login_name FROM @accounts);
			SET @alter = 'ALTER LOGIN ['+@loginName+'] '+@status;
			EXEC(@alter);
			
			IF (@PRINT = 1)
				PRINT @alter;

			DELETE FROM @accounts WHERE login_name = @loginName;
	END

	--Check that account logins were disabled
	EXEC(@select);

	IF (@PRINT = 1)
		PRINT @select;

	IF (@test = 0)
		COMMIT;
	ELSE
		ROLLBACK;
/*====================================================================================*/
