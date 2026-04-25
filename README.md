#  Library Management System — Oracle SQL

A beginner-friendly, fully functional SQL project built for **Oracle Database 12c+**.  
Covers schema design, sample data, and 10 progressively advanced queries — from basic SELECTs to a live dashboard summary.

> Originally written for MySQL/PostgreSQL and fully ported to Oracle SQL with detailed comments explaining every difference.

---

## 🌐 Live Demo

🔗 https://oracle-library-management-sql.vercel.app/

---

##  Features

- Clean, normalized schema with 4 tables and proper foreign key constraints
- Realistic sample data: 5 categories, 8 books, 5 members, 6 loan records
- 10 SQL queries ranging from beginner to intermediate
- Oracle-specific syntax with inline comments explaining each decision
- Safe re-runnable setup (drops tables without errors if they already exist)

---

##  Schema Overview

```
categories ──< books ──< loans >── members
```

| Table | Purpose |
|---|---|
| `categories` | Book genres (Programming, Science, Fiction…) |
| `members` | Library card holders with active/inactive status |
| `books` | Collection with total and available copy counts |
| `loans` | Borrowing records with due dates, returns, and fines |

---

##  Queries Included

| # | Query | Concepts |
|---|---|---|
| Q1 | Available books | JOIN, WHERE, ORDER BY |
| Q2 | Active members | Boolean via NUMBER(1) |
| Q3 | Currently borrowed books | NULL check, SYSDATE, date arithmetic |
| Q4 | Books per category | LEFT JOIN, GROUP BY, COUNT, SUM |
| Q5 | Most borrowed books | Aggregation, FETCH FIRST |
| Q6 | Members with fines | HAVING via WHERE + GROUP BY |
| Q7 | Member borrowing history | TO_CHAR, COALESCE |
| Q8 | Books never borrowed | LEFT JOIN + NULL check |
| Q9 | Monthly loan statistics | EXTRACT, CASE WHEN |
| Q10 | Dashboard summary | Scalar subqueries, DUAL |

---

##  Quick Start

### Prerequisites

- Oracle Database 12c or later (XE edition works fine)
- SQL\*Plus, SQL Developer, or any Oracle-compatible client

### Run the script

```bash
sqlplus username/password@localhost:1521/XE @library_management_oracle.sql
```

Or paste the contents directly into SQL Developer and run as a script (F5).

---

##  Key Oracle vs MySQL/PostgreSQL Differences

| Concept | MySQL / PostgreSQL | Oracle (this project) |
|---|---|---|
| String type | `VARCHAR` | `VARCHAR2` |
| Boolean | `BOOLEAN` | `NUMBER(1)` + CHECK constraint |
| Drop if exists | `DROP TABLE IF EXISTS` | `BEGIN/EXCEPTION/END` block |
| Date literal | `'2024-01-01'` | `DATE '2024-01-01'` |
| Current date | `CURRENT_DATE` | `TRUNC(SYSDATE)` |
| Top-N rows | `LIMIT n` | `FETCH FIRST n ROWS ONLY` |
| Date to string | `CAST(date AS VARCHAR)` | `TO_CHAR(date, 'YYYY-MM-DD')` |
| Standalone SELECT | `SELECT 1` | `SELECT 1 FROM DUAL` |
| Commit | implicit (autocommit) | explicit `COMMIT` |

---

##  File Structure

```
oracle-library-management-sql/
│
├── library_management_oracle.sql   # Main file — schema + data + queries
└── README.md
```

---

##  Who This Is For

- Students learning SQL for the first time
- Developers migrating from MySQL or PostgreSQL to Oracle
- Anyone building a portfolio project with a real-world schema

---

##  License

MIT — free to use, modify, and share.

---

##  If this helped you, drop a star!
