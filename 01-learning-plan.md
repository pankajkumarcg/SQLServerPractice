# SQL Interview Prep - 2-Week Intensive Plan

## Philosophy
Focus ONLY on what interviews actually test. Skip theory — practice patterns.

---

## Week 1: Core SQL (The 80% that matters)

### Day 1: SELECT + WHERE + ORDER BY
- SELECT specific columns, aliases (AS)
- WHERE with =, !=, <, >, BETWEEN, IN, LIKE
- IS NULL / IS NOT NULL
- ORDER BY (ASC/DESC), TOP n (T-SQL — not LIMIT)
- **Interview pattern**: "Find all X where condition Y"

### Day 2: Aggregation + GROUP BY + HAVING
- COUNT, SUM, AVG, MIN, MAX
- COUNT(*) vs COUNT(col) vs COUNT(DISTINCT col)
- GROUP BY (single & multiple columns)
- HAVING vs WHERE (filtering groups vs rows)
- **Interview pattern**: "Find the top N / average / total per group"

### Day 3: JOINs (Most tested topic)
- INNER JOIN — only matching rows
- LEFT JOIN — all left + matching right (NULL for no match)
- Self-join — employee/manager, hierarchies
- Multi-table joins (3+ tables)
- **Interview pattern**: "Show X with related info from Y"
- **Trap question**: "Find records with NO match" → LEFT JOIN + WHERE IS NULL

### Day 4: Subqueries
- Subquery in WHERE: `WHERE col > (SELECT AVG...)`
- Subquery with IN: `WHERE id IN (SELECT ...)`
- EXISTS / NOT EXISTS
- Correlated vs non-correlated
- **Interview pattern**: "Find X that satisfies a condition about Y"

### Day 5: CTEs (Common Table Expressions)
- WITH clause syntax
- Chaining multiple CTEs
- When to use CTE vs subquery vs JOIN
- **Interview pattern**: Break complex problems into readable steps

### Day 6-7: Practice Day (Mock Interview Questions)
- Solve 10-15 medium-difficulty problems
- Time yourself (aim for 10-15 min per question)
- Review mistakes

---

## Week 2: Advanced + Interview Favorites

### Day 8: Window Functions (Very common in interviews)
- ROW_NUMBER() — unique ranking
- RANK() / DENSE_RANK() — ranking with ties
- Running totals: SUM() OVER (ORDER BY ...)
- LAG() / LEAD() — compare to previous/next row
- PARTITION BY — window within groups
- **Interview pattern**: "Rank/compare within groups", "Find Nth highest"

### Day 9: CASE WHEN + String/Date Functions
- CASE WHEN for conditional logic (bucketing, labeling)
- COALESCE for NULL handling
- Date functions (T-SQL): YEAR(), MONTH(), DATEADD(), DATEDIFF(), DATEPART()
- String (T-SQL): + or CONCAT(), UPPER, LOWER, SUBSTRING, LEN
- NOTE: booleans are BIT (1/0); TOP/OFFSET-FETCH instead of LIMIT
- **Interview pattern**: "Categorize/label data based on conditions"

### Day 10: UNION + Set Operations
- UNION vs UNION ALL
- Combining result sets
- INTERSECT / EXCEPT (less common but know them)
- **Interview pattern**: "Combine data from different sources"

### Day 11: Query Optimization & Theory
- Indexes — what they are, when to use them
- Execution plan — how to read it
- N+1 problem, query cost
- Normalization (1NF, 2NF, 3NF) — just definitions
- ACID properties — one-liner each
- **Interview pattern**: "How would you optimize this slow query?"

### Day 12-13: Real Interview Questions Practice
- Solve 15-20 actual interview-style problems
- Focus on: JOINs, window functions, CTEs, aggregation
- Practice explaining your approach out loud

### Day 14: Review & Weak Spots
- Revisit any topic you struggled with
- Write a personal "cheat sheet" of patterns
- Do 5 timed questions as final rehearsal

---

## Top 10 Interview Patterns (Memorize These)

| # | Pattern | Key Technique |
|---|---------|--------------|
| 1 | Find Nth highest salary | DENSE_RANK() or OFFSET-FETCH |
| 2 | Find duplicates | GROUP BY + HAVING COUNT > 1 |
| 3 | Find records with no match | LEFT JOIN + WHERE IS NULL |
| 4 | Running total / cumulative sum | SUM() OVER (ORDER BY ...) |
| 5 | Top N per group | ROW_NUMBER() OVER (PARTITION BY) |
| 6 | Year-over-year comparison | Self-join or LAG() on year |
| 7 | Find consecutive days/values | LAG/LEAD or self-join with date math |
| 8 | Pivot data (rows to columns) | CASE WHEN + GROUP BY |
| 9 | Customer retention/churn | EXISTS + date comparisons |
| 10 | Delete duplicates keeping one | CTE + ROW_NUMBER + DELETE |

---

## Must-Know Theory (Quick Answers)

### What is a PRIMARY KEY?
Unique identifier for each row. Cannot be NULL. One per table.

### What is a FOREIGN KEY?
References a PRIMARY KEY in another table. Enforces relationships.

### WHERE vs HAVING?
WHERE filters rows BEFORE grouping. HAVING filters AFTER GROUP BY.

### UNION vs UNION ALL?
UNION removes duplicates (slower). UNION ALL keeps all rows (faster).

### DELETE vs TRUNCATE vs DROP?
- DELETE: removes rows (can use WHERE, logged, rollback possible)
- TRUNCATE: removes ALL rows (faster, minimal logging)
- DROP: removes the entire table structure

### What are Indexes?
Data structure that speeds up reads at the cost of slower writes.
Use on: frequently filtered columns, JOIN keys, ORDER BY columns.

### ACID Properties?
- **A**tomicity: All or nothing
- **C**onsistency: Valid state before and after
- **I**solation: Concurrent transactions don't interfere
- **D**urability: Committed data survives crashes

### Normalization (1NF → 3NF)?
- **1NF**: No repeating groups, atomic values
- **2NF**: 1NF + no partial dependency on composite key
- **3NF**: 2NF + no transitive dependency

---

## Daily Time Investment

| Activity | Time |
|----------|------|
| Learn concept | 30 min |
| Practice exercises | 60 min |
| Review solutions | 30 min |
| **Total per day** | **~2 hours** |

---

## Recommended Practice Platforms

1. **LeetCode SQL** — Most popular for interview prep
2. **HackerRank SQL** — Good structured difficulty levels
3. **StrataScratch** — Real company interview questions
4. **DataLemur** — SQL interview focused

Use the mock database in this package for hands-on practice before moving to platforms.
