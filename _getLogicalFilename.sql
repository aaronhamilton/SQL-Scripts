use master
go


SELECT db.database_id, db.Name, mf.type, mf.type_desc, mf.name as 'Logical name', mf.name, mf.physical_name
FROM sys.databases db 
INNER JOIN sys.master_files mf on db.database_id = mf.database_id
--where db.name = 'MMS'
where db.name = 'Phoenix_DocumentMigration_Mappings'


SELECT *, name 'Logical Name', physical_name 'File Location' FROM sys.master_files


