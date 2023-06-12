# Analyzing eCommerce Business Performance with SQL
Dataset : [Ecommerce Dataset](https://github.com/jedijm/Analyzing-eCommerce-Business-Performance-with-SQL/tree/master/Dataset) - Rakamin Academy 
Tools : PostgreSQL & Tableau Public

## Project Background
The dataset analyzed in this project comes from one of the biggest e-commerce company in South America. The company is a marketplace that connects micro-scale sellers and the customers. The company wants to analyze the customer growth, product quality and payment types through this project. The project is performed by me as a Data Analytics team of the company.

## Data Preparation
This stage is a fundamental before beginning the data processing. This stage purpose is to turn the raw data into structured data. The steps in this stage are as of below:
1. Create the database with its tables.
2. Import the csv data into the database.
3. Create the Entity Relationship Diagram (ERD) based on scheme in Fig 1. Data Relationship.

![Data Relationship](Figures/Data+Relationship.png "Fig 1. Data Relationship")

From the scheme above, the primary key and foreign key from columns of the table is defined to connect each of the tables in database. Then, the ERD can be generated as in Fig 2. 
![ERD](Figures/ERD.png)

## Data Analysis
In this stage, there are 3 metrics used:
1. Annual Customer Activity Growth Analysis
Annual Customer Activity Growth can be analyzed from Monthly Active User (MAU), total new customer, total customer with repeat order, average order.
