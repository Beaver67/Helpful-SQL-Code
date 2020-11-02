USE []		--Database Name
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET CONCAT_NULL_YIELDS_NULL ON
GO

/****************************************************************************************************************
** Author:		Don Branthwaite, www.bluelizard.com
** Create date: 01/01/2017
** Description:	 
*****************************************************************************************************************
** Change History
**************************
** #    Date        Author		Description 
** --   --------   -------		------------------------------------
** 1    01/10/2017  DB			added  inner join
*******************************/

CREATE PROCEDURE [dbo].[]
--Optional Variables
--(
--@Variable INT
--)
AS

BEGIN
	SET NOCOUNT ON			--SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET ARITHABORT ON
	SET XACT_ABORT ON		-- open transaction is rolled back and execution is aborted

   BEGIN TRY
      BEGIN TRANSACTION

--************************ DECLARE VARIABLES ********************************************************************



--************************ INSERT CODE HERE *********************************************************************




	COMMIT TRANSACTION
	END TRY

--************************ ERROR HANDLING ************************************************************************
BEGIN CATCH
    Declare @lineNum VarChar(1000)
    Declare @errMessage nVarChar(1000)
    
    Select @lineNum = CAST(ERROR_LINE() As Varchar)
    Select @errMessage = 'Proc ' + OBJECT_NAME(@@PROCID) + ' - error line #' + @lineNum + ': ' + ERROR_MESSAGE()
        
    IF XACT_STATE() = -1 AND @@TRANCOUNT >= 1
        Begin
            Rollback Transaction
        End
        
    RAISERROR(@errMessage, 16, 1)
END CATCH

	
SET NOCOUNT OFF
END
GO


