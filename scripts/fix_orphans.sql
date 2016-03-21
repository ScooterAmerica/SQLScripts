/************************************************************
                Author: Jeffrey Sciamanna
        Creation Date: 12-09-2014

        Description:
		Finds and generates the statements needed 
		to remap users to logins after a db restore
************************************************************/

/**************************************************************************************
	First let's handle the orphaned users as a result of this restore.
**************************************************************************************/

-- Use a CTE to get all the Orphaned Users
WITH orphanUsers (name, [type], [sid])
AS
(
	SELECT name, [type], [sid] 
	FROM sys.database_principals
	WHERE [type] = 'S' AND name NOT IN ('dbo', 'guest', 'INFORMATION_SCHEMA', 'sys') --exclude system users
)

-- Now let's generate the statements
	SELECT o.*,'ALTER USER '+o.name+' WITH LOGIN = '+o.name+';' AS User_Fix
	FROM orphanUsers o
	LEFT JOIN sys.server_principals AS sp ON o.sid = sp.sid
	WHERE sp.name IS NULL

/*------------------------------------------------*/
	-- Paste and Run Statements here.
/*------------------------------------------------*/

/*------------------------------------------------*/
