	--Provides a listing of object differences between a source and destination table
	--Includes things such as SP, VW, Constraints, Key Constraints, Tables
	--It provides a listing of what is missing in each database.
	
	DECLARE @Sourcedb sysname 
    DECLARE @Destdb sysname 
    DECLARE @SQL varchar(max) 
     
    SELECT @Sourcedb = 'ePAC_Dev' 
    SELECT @Destdb = 'ePAC_Prod' 


    SELECT @SQL = '

	IF OBJECT_ID(''tempdb..##Temp'') IS NOT NULL
	DROP TABLE ##Temp

	 SELECT ISNULL(SoSource.name,SoDestination.name) ''Object Name'' 
                         , CASE  
                           WHEN SoSource.object_id IS NULL      THEN SoDestination.type_desc +  '' missing in the source -- '  
                                                                                             + @Sourcedb + ''' COLLATE database_default 
                           WHEN SoDestination.object_id IS NULL THEN SoSource.type_desc      +  '' missing in the Destination -- ' + @Destdb  
                                                                                             + ''' COLLATE database_default 
                           ELSE SoDestination.type_desc + '' available in both Source and Destination'' COLLATE database_default 
                           END ''Status'' 

						   INTO ##Temp

                     FROM (SELECT * FROM ' + @Sourcedb + '.SYS.objects  
                            WHERE Type_desc not in (''INTERNAL_TABLE'',''SYSTEM_TABLE'',''SERVICE_QUEUE'')) SoSource  
          FULL OUTER JOIN (SELECT * FROM ' + @Destdb + '.SYS.objects  
                            WHERE Type_desc not in (''INTERNAL_TABLE'',''SYSTEM_TABLE'',''SERVICE_QUEUE'')) SoDestination 
                       ON SoSource.name = SoDestination.name COLLATE database_default 
                      AND SoSource.type = SoDestination.type COLLATE database_default 
                      ORDER BY isnull(SoSource.type,SoDestination.type)
					  
					 SELECT * FROM ##Temp
					 WHERE Status LIKE ''%missing%''
					 ' 
	

    EXEC (@Sql)