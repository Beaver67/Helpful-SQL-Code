--USE 

DECLARE @table_name sysname
DECLARE @schema_name sysname
SET @schema_name = 'dbo'

DECLARE myCursor cursor
FOR SELECT TABLE_NAME
      FROM INFORMATION_SCHEMA.TABLES T
     WHERE T.TABLE_SCHEMA = @schema_name
       AND T.TABLE_TYPE = 'BASE TABLE'
       AND T.TABLE_NAME NOT LIKE 'MSmerge%'
       AND T.TABLE_NAME NOT LIKE 'sysmerge%'
       AND T.TABLE_NAME NOT LIKE 'tmp%'
     ORDER BY T.TABLE_NAME

OPEN myCursor

FETCH NEXT 
FROM myCursor
INTO @table_name 

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @column_list nvarchar(MAX)
    SET @column_list=''
SELECT @column_list = @column_list + CASE WHEN DATA_TYPE IN ('xml','text','ntext','image sql_variant') THEN 'CONVERT(nvarchar(MAX),'
                                          ELSE ''
                                     END
                                   + QUOTENAME(COLUMN_NAME)
                                   + CASE WHEN DATA_TYPE IN ('xml','text','ntext','image sql_variant') THEN ' /* ' + DATA_TYPE + ' */)'
                                          ELSE ''
                                     END + ', '
  FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_NAME = @Table_name
     ORDER BY ORDINAL_POSITION

    SET @column_list = LEFT(@column_list, LEN(@column_list)-1) -- remove trailing comma

    DECLARE @sql AS nvarchar(MAX)
    SET @sql = 'SELECT ''' + QUOTENAME(@schema_name) + '.' + QUOTENAME(@table_name) + ''' table_name,
       CHECKSUM_AGG(CHECKSUM(' + @column_list + ')) CHECKSUM
  FROM ' + QUOTENAME(@schema_name) + '.' + QUOTENAME(@Table_name) + ' WITH (NOLOCK)'


    PRINT  @sql

    FETCH NEXT 
    FROM myCursor
    INTO @table_name 

    IF @@FETCH_STATUS = 0
        PRINT  'UNION ALL'

END

CLOSE myCursor
DEALLOCATE myCursor
