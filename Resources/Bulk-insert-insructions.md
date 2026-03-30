There are multiple ways to insert data into tables. You can choose any of the following ways:

Use INSERT INTO Statement to insert data;
The Bulk insert function can insert data into each table.

The following video shows how to use bulk insert:
https://www.youtube.com/watch?v=KKiaX0vfulcLinks to an external site.


You can import Excel files into MS SQL Server using the management studio (note: you can search youtube.com to find some valuable videos teaching how to import data)
 

BULK INSERT (table name)

FROM ‘C:\ —> This is the place where your Excel file is stored. You may want to save each table in a separate .csv file. 
```sql
WITH (

               FORMAT = ‘CSV’,

               FIRSTROW = 2,

               FIELDTERMINATOR = ‘,’,

               ROWTERMINATOR = ‘\n’,

               BATCHSIZE = 25000,

               MAXERRORS =2

);

GO
```