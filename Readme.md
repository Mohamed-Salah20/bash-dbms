# Bash Shell Script Database Management System (DBMS) Project Requirements:

The project aims to develop a DBMS that will enable users to store and retrieve data from the hard disk.

## Project Features:
The application will be a CLI menu-based app, providing users with the following menu items:

### Main Menu:
- Create Database
- List Databases
- Connect To Databases
- Drop Database

Upon connecting to a specific database, there will be a new screen with the following menu:
- Create Table 
- List Tables
- Drop Table
- Insert into Table
- Select From Table
- Delete From Table
- Update Row

## Hints:
- The database will be stored as a directory relative to the current script file.
- Avoid using absolute paths in your scripts.
- Tables will be stored in files, which can be CSV, JSON, or XML file format.
- You can divide the table info into two tables: Metadata and Raw Data in separate files or the same file.
- When creating a table, the metadata of the table will include: Table Name, Number of Columns, Name of Columns.
- There is an assumption that the first column is the Primary Key, which is used for deleting rows.
- The selection of rows will be displayed on the screen/terminal in an accepted/good human format.
- Keep track of data types (digits or strings) of columns and validate user input based on it.
