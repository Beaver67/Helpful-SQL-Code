--This compares the views of 2 databases and determines which ones have equal definitions
--MUST be used with [udf-Str-Strip-Control] function (Filename: BL_RemoveALLSpace_SPCompare.sql)
--CREATE the function in SOURCE
DECLARE @Sourcedb sysname 
DECLARE @Destdb sysname 
DECLARE @SQLView varchar(max) 
 
SELECT @Sourcedb = 'ePAC_Dev' 
SELECT @Destdb   = 'ePAC_Prod' 

SELECT @SQLView = '
IF OBJECT_ID(''tempdb..#TempView'') IS NOT NULL
DROP TABLE #TempView

SELECT  s.TABLE_CATALOG S_DB,s.TABLE_NAME S_TB,s.VIEW_DEFINITION S_Definition,d.TABLE_CATALOG D_DB,d.TABLE_NAME D_TB,d.VIEW_DEFINITION D_Definition
INTO #TempView
FROM ' + @Sourcedb + '.INFORMATION_SCHEMA.VIEWS s
FULL OUTER Join ' + @Destdb + '.INFORMATION_SCHEMA.VIEWS d
ON s.TABLE_NAME = d.TABLE_NAME

UPDATE #TempView SET S_Definition = CHECKSUM([' + @Sourcedb + '].dbo.[udf-Str-Strip-Control](S_Definition))
WHERE S_Definition is Not Null
Update #TempView SET S_Definition = replace(S_Definition,'' '','''')
WHERE S_Definition is Not Null
UPDATE #TempView SET D_Definition = [' + @Sourcedb + '].dbo.[udf-Str-Strip-Control](D_Definition)
WHERE D_Definition is Not Null
Update #TempView SET D_Definition = replace(D_Definition,'' '','''')
WHERE D_Definition is Not Null

SELECT 
S_DB,S_TB,S_Definition,D_DB,D_TB,D_Definition,
CASE WHEN S_Definition <> D_Definition THEN ''Definitions are not equal'' END as Comment
FROM #TempView
WHERE S_Definition <> D_Definition
'
EXEC (@SqlView)
