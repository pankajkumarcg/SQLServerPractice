# SQL Interview Prep - 2-Week Intensive

A focused, no-fluff SQL preparation plan designed specifically for technical interviews.
Covers only the patterns that actually get asked.

## Files

| File                        | What It Contains                                      |
| --------------------------- | ----------------------------------------------------- |
| `01-learning-plan.md`       | 2-week day-by-day study plan + theory cheat sheet     |
| `02-mock-database.sql`      | Realistic database (9 tables, 420+ rows) for practice |
| `03-practice-exercises.sql` | 40 interview-pattern exercises with solutions         |

## Quick Start

1. Open **SQL Server Management Studio (SSMS)** and connect to your server.
2. Open `02-mock-database.sql` and run it **once** (press F5). It automatically
   creates the `SqlPractice` database, builds all 9 tables, and loads the data.
3. Confirm the `SqlPractice` database is selected in the toolbar dropdown.
4. Open `03-practice-exercises.sql` and run the queries **one at a time**
   (highlight a query, press F5) — working through it day by day.

> All scripts are written in **T-SQL (Microsoft SQL Server)** — booleans use `BIT` (1/0),
> string concatenation uses `+`, dates use `YEAR()` / `DATEADD()`, and paging uses
> `TOP` / `OFFSET-FETCH`.

Tip: Try solving each exercise BEFORE looking at the solution!

## 2-Week Schedule At-a-Glance

| Day   | Topic                 | Key Pattern                  |
| ----- | --------------------- | ---------------------------- |
| 1     | SELECT + WHERE        | Basic filtering              |
| 2     | GROUP BY + HAVING     | Aggregation                  |
| 3     | JOINs                 | INNER, LEFT, Self-join       |
| 4     | Subqueries            | WHERE, EXISTS, Correlated    |
| 5     | CTEs                  | WITH clause, chaining        |
| 6-7   | Practice              | Timed mock problems          |
| 8     | Window Functions      | RANK, ROW_NUMBER, LAG        |
| 9     | CASE WHEN             | Bucketing, pivoting          |
| 10    | UNION                 | Set operations               |
| 11    | Optimization + Theory | Indexes, ACID, Normalization |
| 12-13 | Real Interview Qs     | Full difficulty problems     |
| 14    | Review                | Weak spots + final drill     |

## Time Investment

~2 hours/day = Interview-ready in 14 days.

## Database Schema Overview

The `SqlPractice` database models a small e-commerce + company system:

- **departments** (8) → **employees** (40, self-referencing manager)
- **customers** (50) → **orders** (80) → **order_items** (120)
- **categories** (12) → **products** (40) ← **suppliers** (10)
- **reviews** (60) linking customers to products
