-- ============================================================
--  Library Management System — SQL Project
--  Beginner-friendly SQL practice project
--  Compatible with: Oracle Database 12c+
--  Author: Your Name
-- ============================================================


-- ============================================================
--  SECTION 1: CREATE TABLES (Schema)
-- ============================================================

-- Drop tables if re-running (order matters due to foreign keys)
-- Oracle does not support DROP TABLE IF EXISTS — use BEGIN/EXCEPTION blocks
BEGIN EXECUTE IMMEDIATE 'DROP TABLE loans';      EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE books';      EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE members';    EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE categories'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Drop sequences if re-running
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_categories'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_members';    EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_books';      EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_loans';      EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Categories table
CREATE TABLE categories (
    category_id   NUMBER        PRIMARY KEY,
    category_name VARCHAR2(50)  NOT NULL UNIQUE
);

-- Members table
-- Oracle has no BOOLEAN; use NUMBER(1) with CHECK (0=FALSE, 1=TRUE)
CREATE TABLE members (
    member_id    NUMBER        PRIMARY KEY,
    full_name    VARCHAR2(100) NOT NULL,
    email        VARCHAR2(100) NOT NULL UNIQUE,
    phone        VARCHAR2(20),
    join_date    DATE          NOT NULL,
    is_active    NUMBER(1)     DEFAULT 1 NOT NULL,
    CONSTRAINT chk_is_active CHECK (is_active IN (0, 1))
);

-- Books table
CREATE TABLE books (
    book_id          NUMBER        PRIMARY KEY,
    title            VARCHAR2(200) NOT NULL,
    author           VARCHAR2(100) NOT NULL,
    isbn             VARCHAR2(20)  UNIQUE,
    category_id      NUMBER        REFERENCES categories(category_id),
    published_year   NUMBER,
    total_copies     NUMBER        DEFAULT 1 NOT NULL,
    available_copies NUMBER        DEFAULT 1 NOT NULL,
    CONSTRAINT chk_copies CHECK (available_copies >= 0)
);

-- Loans table (tracks who borrowed which book)
CREATE TABLE loans (
    loan_id      NUMBER PRIMARY KEY,
    book_id      NUMBER NOT NULL REFERENCES books(book_id),
    member_id    NUMBER NOT NULL REFERENCES members(member_id),
    loan_date    DATE   NOT NULL,
    due_date     DATE   NOT NULL,
    return_date  DATE,                           -- NULL = not yet returned
    fine_amount  NUMBER(6,2) DEFAULT 0.00        -- calculated on return
);


-- ============================================================
--  SECTION 2: INSERT SAMPLE DATA
-- ============================================================

-- Categories
INSERT INTO categories (category_id, category_name) VALUES (1, 'Programming');
INSERT INTO categories (category_id, category_name) VALUES (2, 'Science');
INSERT INTO categories (category_id, category_name) VALUES (3, 'History');
INSERT INTO categories (category_id, category_name) VALUES (4, 'Fiction');
INSERT INTO categories (category_id, category_name) VALUES (5, 'Self-Help');

-- Members
-- is_active: 1 = TRUE, 0 = FALSE
INSERT INTO members (member_id, full_name, email, phone, join_date, is_active)
  VALUES (1, 'Ahmed Khan',  'ahmed@example.com',  '0300-1234567', DATE '2023-01-15', 1);
INSERT INTO members (member_id, full_name, email, phone, join_date, is_active)
  VALUES (2, 'Sara Ali',    'sara@example.com',   '0301-2345678', DATE '2023-03-20', 1);
INSERT INTO members (member_id, full_name, email, phone, join_date, is_active)
  VALUES (3, 'Bilal Raza',  'bilal@example.com',  '0302-3456789', DATE '2023-06-01', 1);
INSERT INTO members (member_id, full_name, email, phone, join_date, is_active)
  VALUES (4, 'Fatima Noor', 'fatima@example.com', '0303-4567890', DATE '2024-01-10', 1);
INSERT INTO members (member_id, full_name, email, phone, join_date, is_active)
  VALUES (5, 'Usman Tariq', 'usman@example.com',  '0304-5678901', DATE '2024-02-28', 0); -- deactivated

-- Books
INSERT INTO books (book_id, title, author, isbn, category_id, published_year, total_copies, available_copies)
  VALUES (1, 'The C Programming Language',  'Kernighan & Ritchie', '978-0131103627', 1, 1988, 3, 2);
INSERT INTO books (book_id, title, author, isbn, category_id, published_year, total_copies, available_copies)
  VALUES (2, 'Clean Code',                  'Robert C. Martin',    '978-0132350884', 1, 2008, 2, 1);
INSERT INTO books (book_id, title, author, isbn, category_id, published_year, total_copies, available_copies)
  VALUES (3, 'A Brief History of Time',     'Stephen Hawking',     '978-0553380163', 2, 1988, 2, 2);
INSERT INTO books (book_id, title, author, isbn, category_id, published_year, total_copies, available_copies)
  VALUES (4, 'Sapiens',                     'Yuval Noah Harari',   '978-0062316097', 3, 2011, 3, 3);
INSERT INTO books (book_id, title, author, isbn, category_id, published_year, total_copies, available_copies)
  VALUES (5, 'Atomic Habits',               'James Clear',         '978-0735211292', 5, 2018, 4, 3);
INSERT INTO books (book_id, title, author, isbn, category_id, published_year, total_copies, available_copies)
  VALUES (6, '1984',                        'George Orwell',       '978-0451524935', 4, 1949, 2, 1);
INSERT INTO books (book_id, title, author, isbn, category_id, published_year, total_copies, available_copies)
  VALUES (7, 'Introduction to Algorithms',  'CLRS',                '978-0262033848', 1, 2009, 1, 0);
INSERT INTO books (book_id, title, author, isbn, category_id, published_year, total_copies, available_copies)
  VALUES (8, 'The Selfish Gene',            'Richard Dawkins',     '978-0198788607', 2, 1976, 2, 2);

-- Loans
-- Oracle date literals use TO_DATE or DATE keyword with YYYY-MM-DD
INSERT INTO loans (loan_id, book_id, member_id, loan_date, due_date, return_date, fine_amount)
  VALUES (1, 1, 1, DATE '2024-03-01', DATE '2024-03-15', DATE '2024-03-14', 0.00);   -- returned on time
INSERT INTO loans (loan_id, book_id, member_id, loan_date, due_date, return_date, fine_amount)
  VALUES (2, 2, 2, DATE '2024-03-05', DATE '2024-03-19', DATE '2024-03-25', 1.50);   -- returned late, fined
INSERT INTO loans (loan_id, book_id, member_id, loan_date, due_date, return_date, fine_amount)
  VALUES (3, 6, 3, DATE '2024-03-10', DATE '2024-03-24', NULL, 0.00);                -- currently borrowed
INSERT INTO loans (loan_id, book_id, member_id, loan_date, due_date, return_date, fine_amount)
  VALUES (4, 7, 4, DATE '2024-03-12', DATE '2024-03-26', NULL, 0.00);                -- currently borrowed
INSERT INTO loans (loan_id, book_id, member_id, loan_date, due_date, return_date, fine_amount)
  VALUES (5, 1, 2, DATE '2024-04-01', DATE '2024-04-15', NULL, 0.00);                -- currently borrowed
INSERT INTO loans (loan_id, book_id, member_id, loan_date, due_date, return_date, fine_amount)
  VALUES (6, 5, 1, DATE '2024-02-01', DATE '2024-02-15', DATE '2024-02-13', 0.00);   -- returned early

COMMIT;


-- ============================================================
--  SECTION 3: QUERIES — From Basic to Advanced
-- ============================================================

-- ----------------------------
-- Q1. List all available books
-- ----------------------------
SELECT
    b.title,
    b.author,
    c.category_name,
    b.available_copies
FROM books b
JOIN categories c ON b.category_id = c.category_id
WHERE b.available_copies > 0
ORDER BY c.category_name, b.title;


-- ----------------------------
-- Q2. All active members
-- (is_active = 1 replaces TRUE in Oracle)
-- ----------------------------
SELECT
    member_id,
    full_name,
    email,
    join_date
FROM members
WHERE is_active = 1
ORDER BY join_date;


-- ----------------------------
-- Q3. Currently borrowed books (not yet returned)
-- Oracle uses SYSDATE instead of CURRENT_DATE
-- Date arithmetic: subtracting dates gives number of days in Oracle
-- ----------------------------
SELECT
    l.loan_id,
    m.full_name       AS borrower,
    b.title           AS book,
    l.loan_date,
    l.due_date,
    -- Days overdue (negative means still within deadline)
    TRUNC(SYSDATE) - l.due_date AS days_overdue
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books   b ON l.book_id   = b.book_id
WHERE l.return_date IS NULL
ORDER BY l.due_date;


-- ----------------------------
-- Q4. Total books per category
-- ----------------------------
SELECT
    c.category_name,
    COUNT(b.book_id)    AS total_books,
    SUM(b.total_copies) AS total_copies
FROM categories c
LEFT JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_name
ORDER BY total_books DESC;


-- ----------------------------
-- Q5. Most borrowed books (all time)
-- Oracle uses FETCH FIRST n ROWS ONLY instead of LIMIT
-- ----------------------------
SELECT
    b.title,
    b.author,
    COUNT(l.loan_id) AS times_borrowed
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY b.book_id, b.title, b.author
ORDER BY times_borrowed DESC
FETCH FIRST 5 ROWS ONLY;


-- ----------------------------
-- Q6. Members who have fines > 0
-- ----------------------------
SELECT
    m.full_name,
    m.email,
    SUM(l.fine_amount) AS total_fines
FROM members m
JOIN loans l ON m.member_id = l.member_id
WHERE l.fine_amount > 0
GROUP BY m.member_id, m.full_name, m.email
ORDER BY total_fines DESC;


-- ----------------------------
-- Q7. Borrowing history for a specific member (member_id = 1)
-- Oracle: use TO_CHAR to convert DATE to string; no CAST(date AS VARCHAR)
-- ----------------------------
SELECT
    b.title,
    l.loan_date,
    l.due_date,
    COALESCE(TO_CHAR(l.return_date, 'YYYY-MM-DD'), 'Not returned yet') AS return_status,
    l.fine_amount
FROM loans l
JOIN books b ON l.book_id = b.book_id
WHERE l.member_id = 1
ORDER BY l.loan_date DESC;


-- ----------------------------
-- Q8. Books never borrowed
-- ----------------------------
SELECT
    b.title,
    b.author,
    c.category_name
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
JOIN categories c ON b.category_id = c.category_id
WHERE l.loan_id IS NULL;


-- ----------------------------
-- Q9. Monthly loan statistics
-- Oracle EXTRACT works the same as standard SQL
-- ----------------------------
SELECT
    EXTRACT(YEAR  FROM loan_date) AS year_num,
    EXTRACT(MONTH FROM loan_date) AS month_num,
    COUNT(*)                                                          AS total_loans,
    SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END)         AS returned,
    SUM(CASE WHEN return_date IS NULL     THEN 1 ELSE 0 END)         AS outstanding
FROM loans
GROUP BY
    EXTRACT(YEAR  FROM loan_date),
    EXTRACT(MONTH FROM loan_date)
ORDER BY year_num, month_num;


-- ----------------------------
-- Q10. Library dashboard summary (single-query overview)
-- Oracle requires FROM DUAL for SELECT without a real table
-- ----------------------------
SELECT
    (SELECT COUNT(*)               FROM books)                          AS total_books,
    (SELECT SUM(total_copies)      FROM books)                          AS total_copies,
    (SELECT SUM(available_copies)  FROM books)                          AS available_copies,
    (SELECT COUNT(*)               FROM members WHERE is_active = 1)    AS active_members,
    (SELECT COUNT(*)               FROM loans   WHERE return_date IS NULL) AS active_loans,
    (SELECT COALESCE(SUM(fine_amount), 0) FROM loans)                   AS total_fines_collected
FROM DUAL;
