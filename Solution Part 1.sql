---- Project Task

SELECT * FROM members;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM BOOKS
SELECT * FROM ISSUED_STATUS
SELECT * FROM return_status;

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"


INSERT INTO BOOKS(ISBN,BOOK_TITLE,CATEGORY,RENTAL_PRICE,STATUS,AUTHOR,PUBLISHER)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
SELECT * FROM BOOKS


-- Task 2: Update an Existing Member's Address

UPDATE MEMBERS
SET MEMBER_ADDRESS='125 Main St'
WHERE MEMBER_ID='C101';
SELECT * FROM MEMBERS

---- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM ISSUED_STATUS

DELETE FROM ISSUED_STATUS
WHERE ISSUED_ID='IS106';

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.


SELECT * FROM ISSUED_STATUS
WHERE ISSUED_EMP_ID='E101'

-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.
	
--APPROACH 1 IF U NEED MEMBER DETAILS
	
SELECT M.MEMBER_ID,
       M.MEMBER_NAME,
	   COUNT(*) AS NUMBER_OF_BOOKS
FROM MEMBERS M
JOIN ISSUED_STATUS I
ON M.MEMBER_ID=I.ISSUED_MEMBER_ID
GROUP BY 1,2
HAVING COUNT(*)>1
ORDER BY 1


-- CTAS
-- Task 6: Create Summary Tables: 
--Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**

CREATE TABLE BOOK_CNTS
AS
SELECT B.ISBN,
       B.BOOK_TITLE,
       COUNT(I.ISSUED_ID)AS NO_ISSUED
FROM BOOKS B
JOIN ISSUED_STATUS I
ON I.ISSUED_BOOK_ISBN=B.ISBN
GROUP BY 1,2

-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM BOOKS
WHERE CATEGORY ='Classic'

-- Task 8: Find Total Rental Income by Category:

SELECT CATEGORY,
       SUM(RENTAL_PRICE) AS TOTAL_RENTAL_INCOME
FROM BOOKS
GROUP BY 1

--Task 9: List Members Who Registered in the Last 180 Days:

INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C111', 'sam', '145 Main St', '2024-06-01'),
('C112', 'john', '133 Main St', '2024-05-01');

DELETE FROM MEMBERS
WHERE MEMBER_ID IN ('C111','C112')
	
SELECT * FROM MEMBERS
WHERE REG_DATE >= CURRENT_DATE - INTERVAL '180 Days'

-- Task 10 List Employees with Their Branch Manager's Name and their branch details:

SELECT E.*,
       B.MANAGER_ID,
	   E1.EMP_NAME AS MANAGER_NAME
FROM EMPLOYEES E 
JOIN BRANCH B
ON B.BRANCH_ID=E.BRANCH_ID
JOIN EMPLOYEES E1
ON B.MANAGER_ID=E1.EMP_ID


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

CREATE TABLE BOOKS_PRICE AS
SELECT * FROM BOOKS
WHERE RENTAL_PRICE > 7

---- Task 12: Retrieve the List of Books Not Yet Returned

SELECT I.ISSUED_BOOK_NAME
FROM ISSUED_STATUS I
LEFT JOIN
RETURN_STATUS R
ON I.ISSUED_ID=R.ISSUED_ID
WHERE R.RETURN_ID IS NULL