USE [Remembering]
GO
/****** Object:  StoredProcedure [dbo].[WRK_Remember]    Script Date: 26.10.2020 13:04:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vasyl
-- Create date: 20201025
-- Description:	RAW- >WRK
-- =============================================
ALTER PROCEDURE  [dbo].[WRK_Remember]
AS
BEGIN
-- =============================================
--				Table Creation
-- =============================================
create table [WRK_Remember_20201026](
	[RawNumber] int identity(1,1),
	[CustomerID] varchar(100),
	[CustomerSince] date,
	[Vehicle] varchar(100),
	[2014] float,
	[2015] float,
	[2016E] float
	)
-- =============================================
--				Drop table
-- =============================================
drop table [WRK_Remember_20201026]
-- =============================================
--				Truncate Table
-- =============================================
truncate table [WRK_Remember_20201026]
-- =============================================
--				Insert Into Table
-- =============================================
insert into [WRK_Remember_20201026] 
	(
	[CustomerID],
	[CustomerSince],
	[Vehicle],
	[2014],
	[2015],
	[2016E]
	)
	select 
	[CustomerID],
	[CustomerSince],
	[Vehicle],
	cast([2014] as float),
	cast([2015] as float),
	cast([2016E] as float)
	from [RAW_Remembering_20201026]
	where isnumeric([2015]) = 1 or [2015] like ''
	--(raw affected 1049998)
	/*
	-----------Excluded Raw-------------------------------
	--Error 2
	SELECT *
  FROM [Remembering].[dbo].[RAW_Remembering_20201026]
  where isnumeric([2015]) = 0 and [2015]<>''
  
  ------------ Adidition check--------------------------------
  --Error 3
	select [CustomerID], count(*)
	from [dbo].[WRK_Remember_20201026]
	group by [CustomerID]
	having count(*) > 1

	select * 
	from [WRK_Remember_20201026]
	where [CustomerID] like '3490750'
----------------------------------------------------------------------
--Error 4
	select * from [WRK_Remember_20201026]
	where year([CustomerSince])<'1965'
--------------------------------------------------------------------------
--Error 5
select max([2014])
from [WRK_Remember_20201026]

select * 
	from [WRK_Remember_20201026]
	where [2014] > 800
-----------------------------------------------------------------------------
*/	
end