Covid Data Cleaning & Analysis using SQL notes
----------------------------------------------------------


For analysing data related to covid deaths and vaccinations and find useful relations from them,  data from the official website https://ourworldindata.org/covid-deaths was extracted at a specific 
point in time. 
The live data changed a lot of times after the time of this analysis, so please use the spreadsheet files included in the project directory to achieve the same results using the queries. 
The spreadsheets are already cleaned and organized for the purpose of this project. 
-----------------------------------------------------------------------------------------------------

The following changes are done to the downloaded xlsx data from the covid website:
- Irrelevant columns removed from the data and only information related to covid deaths, cases, tests, vaccinations and anything relevant to the purpose of this analysis are kept.
- The singular dataset file is then divided into two broad files called CovidDeaths and CovidVaccinations containing data related to deaths and vaccinations respectively.
------------------------------------------------------------------------------------------------------

A few points to note to ensure succesful import/use of this data:

- The queries used here are preferred for MS-SQL Server and Management Studio. They might not work in MySQL or PostgreSQL environments. Make sure to use the latest Microsoft SQL clients.

- Make sure to use the import/export wizard from the start menu or main directory instead of -- by right-clicking on the database. Through start menu or main directory, you use 64-bit wizard 
and NOT 32-bit wizard. The dataset of this size would not import through the 32-bit wizard.
************************************************************************************************
Go to start menu>> scroll to find Microsoft SQL Server folder and expand it>> Click on **** 
SQL Server Import/Export wizard. This will use the 64-bit wizard. ****************************
************************************************************************************************

- DO NOT USE .CSV but a .XLSX. If you import a flat file (csv), all the null values in the data 
will be automatically turned to 0. During analysis, when values get divided, it will cause null values to not get ignored and instead result in a 'divided by 0' error. The datasets included in 
the project are already in .xlsx format, so just use those.
- While using the 64-bit import/export wizard and an excel file (for reasons stated above), it is imperative that you have 64-bit MS-Excel installed on your computer, otherwise the option for
an Excel file will not appear in the source selection dropdown in the import wizard.
*************************************************************************************************
HAVE 64-bit MS-EXCEL INSTALLED ON YOUR SYSTEM ****************************************
*************************************************************************************************

