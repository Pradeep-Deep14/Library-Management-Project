# Library Management System using SQL Project

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/Pradeep-Deep14/Library-Management-Project/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/Pradeep-Deep14/Library-Management-Project/blob/main/library_erd.png)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_db;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO BOOKS(ISBN,BOOK_TITLE,CATEGORY,RENTAL_PRICE,STATUS,AUTHOR,PUBLISHER)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
SELECT * FROM BOOKS

```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE MEMBERS
SET MEMBER_ADDRESS='125 Main St'
WHERE MEMBER_ID='C101';
SELECT * FROM MEMBERS
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
SELECT * FROM ISSUED_STATUS

DELETE FROM ISSUED_STATUS
WHERE ISSUED_ID='IS106';

```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM ISSUED_STATUS
WHERE ISSUED_EMP_ID='E101'
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT M.MEMBER_ID,
       M.MEMBER_NAME,
	   COUNT(*) AS NUMBER_OF_BOOKS
FROM MEMBERS M
JOIN ISSUED_STATUS I
ON M.MEMBER_ID=I.ISSUED_MEMBER_ID
GROUP BY 1,2
HAVING COUNT(*)>1
ORDER BY 1
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE BOOK_CNTS
AS
SELECT B.ISBN,
       B.BOOK_TITLE,
       COUNT(I.ISSUED_ID)AS NO_ISSUED
FROM BOOKS B
JOIN ISSUED_STATUS I
ON I.ISSUED_BOOK_ISBN=B.ISBN
GROUP BY 1,2
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

**Task 7. Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM BOOKS
WHERE CATEGORY ='Classic'
```

**Task 8.Find Total Rental Income by Category**:

```sql
SELECT CATEGORY,
       SUM(RENTAL_PRICE) AS TOTAL_RENTAL_INCOME
FROM BOOKS
GROUP BY 1
```

**Task 9. List Members Who Registered in the Last 180 Days**:
```sql
INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C111', 'sam', '145 Main St', '2024-06-01'),
('C112', 'john', '133 Main St', '2024-05-01');

DELETE FROM MEMBERS
WHERE MEMBER_ID IN ('C111','C112')
	
SELECT * FROM MEMBERS
WHERE REG_DATE >= CURRENT_DATE - INTERVAL '180 Days'
```

**Task 10.List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT E.*,
       B.MANAGER_ID,
	   E1.EMP_NAME AS MANAGER_NAME
FROM EMPLOYEES E 
JOIN BRANCH B
ON B.BRANCH_ID=E.BRANCH_ID
JOIN EMPLOYEES E1
ON B.MANAGER_ID=E1.EMP_ID
```

**Task 11.Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE BOOKS_PRICE AS
SELECT * FROM BOOKS
WHERE RENTAL_PRICE > 7
```

**Task 12: Retrieve the List of Books Not Yet Returned**
```sql
SELECT I.ISSUED_BOOK_NAME
FROM ISSUED_STATUS I
LEFT JOIN
RETURN_STATUS R
ON I.ISSUED_ID=R.ISSUED_ID
WHERE R.RETURN_ID IS NULL
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT i.issued_member_id,
       m.member_name,
       b.book_title,
       i.issued_date,
	   --r.return_date,
	  (CURRENT_DATE - i.issued_date)  AS over_due_days
FROM issued_status i
JOIN members as m ON m.member_id=i.issued_member_id
JOIN books as b ON b.isbn=i.issued_book_isbn
LEFT JOIN return_status as r
ON r.issued_id=i.issued_id
WHERE r.return_date IS NULL
AND (CURRENT_DATE - i.issued_date)>30
ORDER BY 1
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

```sql

CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$
```
-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');

-- calling function 
CALL add_return_records('RS148', 'IS140', 'Good');

**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
CREATE TABLE Branch_Reports 
AS
SELECT 	b.branch_id,
 		b.manager_id,
        count(i.issued_id) AS number_of_books_issued,
        count(r.return_id) AS number_of_books_returned,
        SUM(bk.rental_price) AS Total_Revenue
FROM issued_status i
JOIN employees e ON e.emp_id=issued_emp_id
JOIN branch b on e.branch_id=b.branch_id
LEFT JOIN return_status r ON r.issued_id=i.issued_id
JOIN books bk ON i.issued_book_isbn = bk.isbn
GROUP BY 1,2

SELECT * FROM Branch_Reports
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

CREATE TABLE active_members
AS
SELECT * FROM MEMBERS 
WHERE member_id IN
(SELECT DISTINCT issued_member_id
FROM issued_status
WHERE issued_date >= CURRENT_DATE - INTERVAL '2 month');

SELECT * FROM ACTIVE_MEMBERS
```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT e.emp_name,
	   b.*,
	   COUNT(i.issued_id) as No_of_book_issued
FROM issued_status i
JOIN employees e
ON e.emp_id=i.issued_emp_id
JOIN branch b
ON e.branch_id=b.branch_id
GROUP BY 1,2
HAVING COUNT(i.issued_id)>3

```

**Task 18: Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.
--MEMBER NAME --> MEMBER TABLE,
--BOOK TITLE --> BOOK TABLE
--RETURN STATUS --> DAMAGEDBOOK COUNT
```sql
SELECT m.member_name,
       b.book_title,
       COUNT(r.book_quality) AS No_Of_times_returned_Damaged_books
FROM issued_status i
JOIN members m ON m.member_id=i.issued_member_id
JOIN books b ON b.isbn=i.issued_book_isbn
LEFT JOIN return_status r ON i.issued_id=r.issued_id
WHERE r.book_quality = 'Damaged'
GROUP BY 1,2
```

**Task 19: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
-- all the variabable
    v_status VARCHAR(10);

BEGIN
-- all the code
    -- checking if book is available 'yes'
    SELECT 
        status 
        INTO
        v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN

        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES
        (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        UPDATE books
            SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        RAISE NOTICE 'Book records added successfully for book isbn : %', p_issued_book_isbn;


    ELSE
        RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
    END IF;
END;
$$

```

**Task 20: Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines
```sql
CREATE TABLE OVERDUE AS
SELECT
    M.MEMBER_ID,
    COUNT(I.ISSUED_BOOK_ISBN) AS NUMBER_OF_OVERDUE_BOOKS,
    COUNT(I.ISSUED_BOOK_ISBN) * 0.50 * (CURRENT_DATE - I.ISSUED_DATE - 30) AS TOTAL_FINES
FROM
    MEMBERS M
JOIN
    ISSUED_STATUS I ON M.MEMBER_ID = I.ISSUED_MEMBER_ID
JOIN
    BOOKS B ON I.ISSUED_BOOK_ISBN = B.ISBN
LEFT JOIN
    RETURN_STATUS R ON I.ISSUED_ID = R.ISSUED_ID
WHERE
    R.RETURN_DATE IS NULL
    AND (CURRENT_DATE - I.ISSUED_DATE) > 30
GROUP BY
    M.MEMBER_ID,
    I.ISSUED_DATE;
```
## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.


