USE [BMCEcommerceReporting]
GO
/****** Object:  StoredProcedure [dbo].[removeDuplicatesFromTable]    Script Date: 12/19/2018 7:06:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Don Branthwaite, www.bluelizard.com
-- Create date: 12/11/2018
-- Description:	Removes all duplicate values based on table and columns specified 
-- =============================================
ALTER		 PROCEDURE [dbo].[removeDuplicatesFromTable] (
@tb NVARCHAR(200),
@strColumns NVARCHAR(1000) )
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
        SET NOCOUNT ON;

		DECLARE @SQL NVARCHAR(MAX)

		SET @SQL = '
		;WITH CTE AS(
		   SELECT ' + @strColumns + ',
			   RN = ROW_NUMBER()OVER(PARTITION BY ' + @strColumns + ' ORDER BY [ga_date])
		   FROM ' + @TB + '
		)
		DELETE FROM CTE WHERE RN > 1
		'

		--Execute the SQL Statement
		EXEC sp_executesql @SQL


    END
