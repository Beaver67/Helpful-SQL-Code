# Helpful-SQL-Code
 Useful SQL Server Code for reference
 
___
# Compares
These scripts are used for a move from a Dev to Prod server where the databases have become out of sync.
The scripts check for differences in contraints, tables defs, views, stored procs and functions.

## CompareObject.sql
Shows differences between the 2 databases for various objects - very good for overview of SP.

## CompareSP.sql
Does a CHECKSUM on the Stored Procs that can be compared for differences.
If there are differences, the BL_CompareOBject can show more detail.

## CompareTable.sql
Compares the tables for any differences to column definitions or structure.

## CompareView.sql
Uses CHECKSUM to compares the views for any differences.
It does not indicate what the exact difference is.

## CreateChecksumTableScripts.sql
This generates code that is to be run to generate a CHECKSUM on a database.
It is run on one database only and then you would run it again on the comparison database.
Copy and paste the results of the 2 runs into excel and compare the CHECKSUM values to get a sense of table differences.

## FindContraints.sql
Provides a listing of the contraints in a given database.
Can run this on the Dev and Prod version and compare manually.

## BL_RemoveALLSpace_SPCompare.sql
To use this function, create the function in the database of record.
Other Stored Procs will use this in order to clean up the stored procs that are being compared.
By cleaning up blank spaces, we can better compare the stored procs in different databases because we will not get false differences as a result of extra spaces in one stored proc vs another.

___
# Misc

## removeDuplicatesFromTable.sql
Removes duplicate values based on an array of columns.
It will remove any duplicates if the columns match up (this way, we can forego any ID values).

## SPTemplate
Blank template that has a proper layout with comments.
