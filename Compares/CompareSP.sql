--This compares the Stored Procs of 2 databases and determines which ones have equal definitions
--MUST be used with [udf-Str-Strip-Control] function (Filename: BL_RemoveALLSpace_SPCompare.sql)
--CREATE the function in SOURCE
--IMPORTANT NOTE
--Getting inconsistent results, therefore the "USE DB Name" construct must be used at the start of each section
DECLARE @Sourcedb sysname 
DECLARE @Destdb sysname 
DECLARE @SQLSP varchar(max) 

SELECT @Sourcedb = 'ePAC_Dev' 
SELECT @Destdb   = 'ePAC_Prod' 

SELECT @SQLSP = '

--SOURCE DB
USE [' + @Sourcedb + ']

IF OBJECT_ID(''tempdb..#TempSPDev'') IS NOT NULL
DROP TABLE #TempSPDev

SELECT s.name,CHECKSUM([' + @Sourcedb + '].dbo.[udf-Str-Strip-Control](OBJECT_DEFINITION(object_id))) S_DEF
INTO #TempSPDev
FROM [' + @Destdb + '].sys.procedures s

--DESTINATION DB
USE [' + @Destdb + ']

IF OBJECT_ID(''tempdb..#TempSPProd'') IS NOT NULL
DROP TABLE #TempSPProd

SELECT d.name,CHECKSUM([' + @Sourcedb + '].dbo.[udf-Str-Strip-Control](OBJECT_DEFINITION(object_id))) D_DEF
INTO #TempSPProd
FROM [' + @Destdb + '].sys.procedures d

--JOIN SOURCE & DESTINATION
--If the 2 DB are in different instances, do the above separately and then use excel to compare
--Omit this step and run Source and Dev in 2 different windows and save the files
select s.name, s.S_DEF,d.D_DEF from ePAC_Dev.#TempSPDev s
JOIN #TempSPProd d
ON s.name = d.name
--WHERE s.S_DEF <> d.D_DEF
'
EXEC (@SQLSP)