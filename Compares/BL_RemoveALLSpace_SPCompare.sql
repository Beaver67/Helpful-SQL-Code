USE 
GO

/****** Object:  UserDefinedFunction [dbo].[udf-Str-Strip-Control]    Script Date: 11/7/2018 12:40:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[udf-Str-Strip-Control]
(@S varchar(max))
Returns varchar(max)
Begin
    ;with  cte1(N) As (Select 1 From (Values(1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) N(N)),
           cte2(C) As (Select Top (32) Char(Row_Number() over (Order By (Select NULL))-1) From cte1 a,cte1 b)
    Select @S = Replace(@S,C,' ')
     From  cte2

    Return ltrim(rtrim(replace(replace(replace(@S,' ','†‡'),'‡†',''),'†‡',' ')))
End
GO