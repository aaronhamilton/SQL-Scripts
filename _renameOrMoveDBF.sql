USE master; --do this all from the master 
/*
--ORIGINAL SETTINGS -----------------------------------------------------------------
DATABASE NAME: Phoenix_DocumentMigration_Mappings
LOGICAL NAME: Phoenix_DocumentMigration_Mappings
PHYSICAL PATH: E:\MSSQL\Data\Phoenix_DocumentMigration_Mappings2.mdf
LOG LOGICAL NAME: Phoenix_DocumentMigration_Mappings_log
LOG LOGICAL PATH: G:\MSSQL\Logs\Phoenix_DocumentMigration_Mappings2.ldf
*/


ALTER DATABASE Phoenix_DocumentMigration_Mappings SET OFFLINE WITH ROLLBACK IMMEDIATE;

-- DB FILE
-- ORIGINAL:E:\MSSQL\Data\Phoenix_DocumentMigration_Mappings2.mdf
-- NEW PATH: F:\MSSQL\Data\Phoenix_DocumentMigration_Mappings.mdf
ALTER DATABASE Phoenix_DocumentMigration_Mappings MODIFY FILE (name='Phoenix_DocumentMigration_Mappings',filename='F:\MSSQL\Data\Phoenix_DocumentMigration_Mappings.mdf'); -- NOTE: Filename is new DB file location

-- LOG FILE
-- new Log file location not specified 

-- NEXT: copy the files over using your favorite method (Click n Drag, XCopy, Copy-Item, Robocopy)

-- NEXT: run the following statement to bring DB back online
-- ALTER DATABASE Phoenix_DocumentMigration_Mappings SET ONLINE;

