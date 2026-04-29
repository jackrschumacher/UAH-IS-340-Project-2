DECLARE @sql NVARCHAR(MAX) = N'';

-- Build the dynamic SQL string
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
    + ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys;

-- Print the SQL to verify it first (optional but recommended)
-- PRINT @sql; 

-- Execute the generated statements
EXEC sp_executesql @sql;