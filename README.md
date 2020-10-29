# ETL-Project-Vachicle-Service  :bike:
[Here you can find data](https://drive.google.com/drive/folders/1GapVeUbtaRsfD8kFoWLpgd22omsdFPUF?usp=sharing)
* There are 5 errors in the data. Find them

The CustomerID field does not contain duplicate records.

Suggest explanations how each of the errors could have occurred 
and what you think is the best way to fix each one.

You know that the total projected revenue for 2016 equals: $419,896,187.87. 
You need the uploaded data to match this value (this means that every row is important).
## First step 

Using Visual Studio with ssdt-bi I automatically excluded  
![](https://github.com/vassylkorzh/ETL-Project-Vachicle-Service/blob/main/img/VisualStudio%20img.PNG)

The condition to split the data into bad and good records was 

`if len(column6)>0 & len(2016E)==0 it all bad raws due to there error `

"CustomerID" | "CustomerSince"| "Vehicle" | "2014" | "2015" | "2016E" | "Column 6"|
-------------|----------------|-----------|--------|--------|---------|-----------|
  2738818    |  2014-01-01    |2009 Chevrolet Traverse|118|01|122.55|725.89

1. 2738818;2014-01-01;2009 Chevrolet Traverse;118;01;122.55;725.89 - error due to 118;01; as for me here it should be 118.01

## The next step was to find error using SQL
### This select help us to find and catch second error

  `SELECT *
  FROM [Remembering].[dbo].[RAW_Remembering_20201026]
  where isnumeric([2015]) = 0 and [2015]<>''`
  
  
RawNumber|  CustomerID | "CustomerSince"| "Vehicle" | "2014" | "2015" | "2016E" |
---------|-------------|----------------|-----------|--------|--------|---------|
676802   |	3211647	   |   2004-12-21	  |1996 Daewoo Brougham|	413.92|	781$37	| 175.80| 	

2. 781$37 - because of this $ I got an error "Cant convert varchar to float "

### To find next error i decided to check is there any duplicate records. And voila, these two select will help us find error 3

  `select [CustomerID], count(*)
	from [dbo].[WRK_Remember_20201026]
	group by [CustomerID]
	having count(*) > 1`
  
  `select * 
	from [WRK_Remember_20201026]
	where [CustomerID] like '3490750'`
  RawNumber|  CustomerID | "CustomerSince"| "Vehicle" | "2014" | "2015" | "2016E" |
  ---------|-------------|----------------|-----------|--------|--------|---------|
  437811   |	3490750    |	2006-05-17    |2007 Tata Sumo|	349,88	|340,62	|517,2
  437812	 |  3490750    |	2006-01-22    |2004 Volkswagen Touran|	735,77|	741,23|	314,09
  
  3. CustomerID = 3490750 repeated twice
### This select help us to find veryyyy old customer 
 
 `select * from [WRK_Remember_20201026]
	where year([CustomerSince])<'1950'`
  
  RawNumber|  CustomerID | "CustomerSince"| "Vehicle" | "2014" | "2015" | "2016E" |
  ---------|-------------|----------------|-----------|--------|--------|---------|
  939893	 |    2942833	 |   1899-04-30   |2001 Jaguar XJR|	610,33|	460,45|156,12|
  
  4. 1899-04-30 - this is a long time ago, so I think this raw can also be considered an error
### To find error number 5, I had to compare all the min and max of the columns 2014 2015 and 2016E 
  
  `select max([2014])
from [WRK_Remember_20201026]`

  Max for 2015 and 2016E was 800 
  and only 2014 showed 20000 
  
` select * 
	from [WRK_Remember_20201026]
	where [2014] > 800`
  
  RawNumber|  CustomerID | "CustomerSince"| "Vehicle" | "2014" | "2015" | "2016E" |
  ---------|-------------|----------------|-----------|--------|--------|---------|
  384712   |	3437651    |	2009-06-27    |	2005 Holden Combo| 20000|	783,96|	122,86
  
  5. 20000 it to much. Error number 5 founded 
  

## Result
#### [SQL Code](https://github.com/vassylkorzh/ETL-Project-Vachicle-Service/blob/main/SQL-Procedure.sql)

419895286,179995 
+ 
175.80 – (Excluded SQL)
+
725.89 – (Excluded SSIS)

= 419,896,187.9
