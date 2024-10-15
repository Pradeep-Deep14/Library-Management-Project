SELECT * FROM members;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM BOOKS
SELECT * FROM ISSUED_STATUS
SELECT * FROM return_status;


/*Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period).
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

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

/*
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes"
when they are returned (based on entries in the return_status table).
*/

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


/*Task 15: Branch Performance Report
Create a query that generates a performance report for each branch,
showing the number of books issued, the number of books returned, 
and the total revenue generated from book rentals.
*/

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

/*Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members
containing members who have issued at least one book in the last 2 months.
*/

CREATE TABLE active_members
AS
SELECT * FROM MEMBERS 
WHERE member_id IN
(SELECT DISTINCT issued_member_id
FROM issued_status
WHERE issued_date >= CURRENT_DATE - INTERVAL '2 month');

SELECT * FROM ACTIVE_MEMBERS

/* Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues.
Display the employee name, number of books processed, and their branch.
*/

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

/*Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table.
Display the member name, book title, and the number of times they've issued damaged books.
*/

--MEMBER NAME --> MEMBER TABLE,
--BOOK TITLE --> BOOK TABLE
--RETURN STATUS --> DAMAGEDBOOK COUNT

SELECT m.member_name,
       b.book_title,
       COUNT(r.book_quality) AS No_Of_times_returned_Damaged_books
FROM issued_status i
JOIN members m ON m.member_id=i.issued_member_id
JOIN books b ON b.isbn=i.issued_book_isbn
LEFT JOIN return_status r ON i.issued_id=r.issued_id
WHERE r.book_quality = 'Damaged'
GROUP BY 1,2

/*
TASK 19:Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system.
Description: Write a stored procedure that updates the status of a book in the library based on its issuance.
The procedure should function as follows: The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/

	
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

-- Testing The function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'

/*Task 20: Create Table As Select (CTAS) Objective: 
Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.*/


/*
Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. 
The table should include: The number of overdue books. 
The total fines, with each day's fine calculated at $0.50. 
The number of books issued by each member.
The resulting table should show: Member ID Number of overdue books Total fines
*/


--MEMBERID
--NUMBER OF OVERDUE BOOKS
--TOTAL FINES

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

