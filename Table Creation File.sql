--Library Management System

--Creating Branch Table

CREATE TABLE BRANCH
	(BRANCH_ID VARCHAR(10) PRIMARY KEY,
	MANAGER_ID VARCHAR(10),
	BRANCH_ADDRESS VARCHAR(55),
	CONTACT_NO VARCHAR(10))

SELECT * FROM BRANCH

ALTER TABLE BRANCH
ALTER COLUMN CONTACT_NO TYPE VARCHAR(20)

-- Creating Employees Table

CREATE TABLE EMPLOYEES
(EMP_ID VARCHAR(10) PRIMARY KEY,
EMP_NAME VARCHAR(25),
POSITION VARCHAR(25),
SALARY INT,
BRANCH_ID VARCHAR(25)) --FK

SELECT * FROM EMPLOYEES

--Creating Books Table

CREATE TABLE BOOKS 
	(isbn VARCHAR(20) PRIMARY KEY,
	 book_title	 VARCHAR(75),
	 category  VARCHAR(10),
	 rental_price FLOAT,
	 status	VARCHAR(15),
	 author	VARCHAR(35),
	 publisher VARCHAR(55)
)


ALTER TABLE books
ALTER COLUMN CATEGORY TYPE VARCHAR(20)
	
SELECT * FROM BOOKS


CREATE TABLE MEMBERS
(member_id VARCHAR(20) PRIMARY KEY,
 member_name VARCHAR(25),
 member_address VARCHAR(75),
 reg_date DATE)

SELECT * FROM MEMBERS

CREATE TABLE ISSUED_STATUS
(issued_id VARCHAR(10) PRIMARY KEY,
issued_member_id VARCHAR(75), --FK
issued_book_name VARCHAR(75),
issued_date	 DATE,
issued_book_isbn VARCHAR(25), -- FK
issued_emp_id VARCHAR(10)); --FK

SELECT * FROM ISSUED_STATUS

CREATE TABLE RETURN_STATUS
(return_id	VARCHAR(10) PRIMARY KEY,
issued_id	VARCHAR(10), --FK
return_book_name VARCHAR(75),
return_date DATE,
return_book_isbn VARCHAR(20)
)

SELECT * FROM RETURN_STATUS

--FOREIGN KEY 

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id)

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn)


ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id)


ALTER TABLE EMPLOYEES
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id)


ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id)

