# Big Data & EDW Learning Progress Report

**Learner:** Nischal Paliwal  
**Roadmap:** Big Data & EDW 
**Report type:** Mentor & RM review  
**Report date:** 19 November 2026

---

## 1. SQL: Basic to Advanced (Project-Ready)

### 1.1 Topics

| # | Level | Topic | Key concepts |
| :-: | :-- | :-- | :-- |
| 1 | Basic | SQL & RDBMS Basics | Tables, rows, columns, MySQL/PostgreSQL setup |
| 2 | Basic | SELECT, WHERE, ORDER BY | Filtering, sorting, DISTINCT, comparison operators |
| 3 | Basic | Data Types & Constraints | INT, VARCHAR, DATE; NOT NULL, UNIQUE, DEFAULT, CHECK |
| 4 | Basic | Keys & Relationships | Primary key, foreign key, referential integrity |
| 5 | Basic | Aggregation | COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING |
| 6 | Basic | Joins | INNER, LEFT, RIGHT, FULL, SELF |
| 7 | Intermediate | Subqueries | SELECT/WHERE/FROM subqueries, correlated subqueries |
| 8 | Intermediate | Set Operations | UNION, UNION ALL, INTERSECT, EXCEPT |
| 9 | Intermediate | CTEs | WITH clause, multiple and recursive CTEs |
| 10 | Intermediate | Window Functions | ROW_NUMBER, RANK, DENSE_RANK, PARTITION BY, LAG/LEAD |
| 11 | Intermediate | DML & Upserts | INSERT, UPDATE, DELETE, MERGE/UPSERT |
| 12 | Intermediate | Views & Indexes | CREATE VIEW, clustered vs non-clustered indexes, execution plans (intro) |
| 13 | Intermediate | Transactions | ACID, COMMIT, ROLLBACK, isolation levels |
| 14 | Advanced | SCD Patterns in SQL | SCD Type 1 and 2 using MERGE, effective-dated columns |
| 15 | Advanced | Analytical SQL | PERCENT_RANK, NTILE, PIVOT/UNPIVOT |
| 16 | Advanced | Stored Procedures & Functions | Parameterized procedures, scalar and table-valued functions |
| 17 | Advanced | Data Warehousing SQL | Querying star/snowflake schemas, fact-dimension joins at scale |

### 1.2 Hands-on Projects

Dataset for all three: [Superstore dataset (Kaggle)](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final).

**Project 1: SQL Filtering & Aggregation on Retail Data**
- Loaded the Superstore data into a SQL database and explored the schema.
- Applied `WHERE` filters on region, category and order date.
- Aggregated sales, quantity and profit with `GROUP BY` and `HAVING`; sorted and limited results to find top products and categories.
- Answered business questions: monthly sales trend and top 5 customers by sales.
- Validated row counts and checked for duplicates.
- Deliverable: SQL script, query results and brief insights.
- Repository: `https://github.com/NischalPaliwal/CLE-Progress/tree/main/SQL`

**Project 2: Advanced SQL: Subqueries, CTEs & Window Functions**
- Created `Customers`, `Orders` and `Products` tables from the raw dataset.
- Used a subquery to find customers with above-average order value.
- Used a CTE to compute total sales per customer.
- Applied `ROW_NUMBER`/`RANK` to find the top 3 orders per customer.
- Combined JOIN + CTE + window functions in one final report query to answer: top customers, single-order customers, above-average-sales customers.
- Deliverable: SQL script, results and brief insights.
- Repository: `https://github.com/NischalPaliwal/CLE-Progress/tree/main/SQL`

**Project 3: SCD Type 2 Upsert Simulation using MERGE**
- Created a customer dimension with `effective_date`, `end_date` and current-flag columns and loaded an initial batch.
- Simulated a changes file with updated customer attributes.
- Wrote a `MERGE` statement that closes out old rows and inserts new versions.
- Validated history with point-in-time queries.
- Deliverable: SQL script, before/after table snapshots and a short explanation.
- Repository: `https://github.com/NischalPaliwal/CLE-Progress/tree/main/SQL`

---

## 2. Azure: ADLS Gen2, ADF & Synapse

### 2.1 Topics

| # | Level | Topic | Key concepts |
| :-: | :-- | :-- | :-- |
| 1 | Basic | Azure Fundamentals | Portal, resource groups, subscriptions, IaaS/PaaS/SaaS |
| 2 | Basic | ADLS Gen2 | Blob vs ADLS Gen2, hierarchical namespace, containers |
| 3 | Basic | ADLS Gen2 Security | RBAC, ACLs, SAS tokens, Managed Identity |
| 4 | Basic | ADF Fundamentals | Pipelines, activities, datasets, linked services |
| 5 | Intermediate | ADF Copy Activity | Source/sink configuration, file formats, Copy Data tool |
| 6 | Intermediate | Mapping Data Flows | Join, filter, derive column, aggregate |
| 7 | Intermediate | ADF Parameterization | Pipeline/dataset parameters, dynamic content |
| 8 | Intermediate | ADF Triggers | Schedule, tumbling window, event-based |
| 9 | Intermediate | Integration Runtime | Azure IR vs self-hosted IR vs Azure-SSIS IR |
| 10 | Intermediate | Synapse Fundamentals | Workspace, serverless vs dedicated SQL pool |
| 11 | Advanced | Metadata-driven Framework | Config-table-driven pipeline pattern |
| 12 | Advanced | ADF Monitoring & Error Handling | Alerts, retries, Log Analytics, failure notifications |
| 13 | Advanced | ADF CI/CD | Git integration, ARM templates, Azure DevOps release pipelines |
| 14 | Advanced | Synapse Spark Pools | Synapse Spark vs SQL pools, when to use each |
| 15 | Advanced | Governance & Cost | Cost management basics, Purview/Unity Catalog overview |

### 2.2 Hands-on Projects

**Project 1: ADLS + ADF: End-to-End Copy Pipeline**
- Dataset: [Superstore dataset (Kaggle)](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final).
- Created a resource group and an ADLS Gen2 storage account with a container organised into Bronze/Silver/Gold folders.
- Uploaded the Superstore CSV to Bronze.
- Created an ADF instance with a linked service to ADLS and built a pipeline using Get Metadata and Copy Data.
- Assigned RBAC roles (Reader/Contributor) for ADF-to-storage access.
- Executed and monitored the pipeline and validated the output file.
- Deliverable: screenshots (resource group, storage, ADF, pipeline run) and a short summary.
- Repository: `https://github.com/NischalPaliwal/azure-data-factory-code`
- Image:
  <img width="1917" height="921" alt="Screenshot 2026-11-18 230824" src="https://github.com/user-attachments/assets/bb223a58-ff36-4a2d-9a60-e8d960d0a9ed" />

**Project 2: Metadata-Driven Ingestion Framework**
- Created a control table listing source file names and target locations.
- Built a pipeline that reads it with `Lookup` and loops with `ForEach`, calling a parameterized `Copy` activity driven by the config values.
- Added logging of success/failure per file (row counts and run timestamps).
- Tested with 3 or more sample files.
- Deliverable: pipeline export, config table and execution log.
- Repository: `https://github.com/NischalPaliwal/azure-data-factory-code`
- Images:
  <img width="1917" height="923" alt="Screenshot 2026-11-18 225124" src="https://github.com/user-attachments/assets/7d45467f-8a54-4679-98b3-71c09edded16" />
  <img width="1917" height="922" alt="Screenshot 2026-11-18 225139" src="https://github.com/user-attachments/assets/7322ff88-d09c-4574-973a-4b79a5ebd05a" />

**Project 3: Incremental Ingestion Pipeline with Watermarks**
- Implemented watermark-based incremental load on `dbo.Orders` using two `Lookup` activities, a `Copy` activity with upsert, and a stored procedure that updates the watermark only after a successful copy.
- Repository: `https://github.com/NischalPaliwal/azure-data-factory-code`
- Images:
  <img width="1917" height="922" alt="Screenshot 2026-11-19 151213" src="https://github.com/user-attachments/assets/0426418f-0de9-4281-b9cf-d8877d58b70c" />
  <img width="1476" height="862" alt="Screenshot 2026-11-19 152551" src="https://github.com/user-attachments/assets/9b3b020f-511c-4732-bd58-dd4024b8e43d" />
  
---

## 3. Data Modelling

### 3.1 Topics

| # | Level | Topic | Key concepts |
| :-: | :-- | :-- | :-- |
| 1 | Basic | Data Modeling Foundations | Conceptual, logical, physical models |
| 2 | Basic | ER Modeling | Entities, attributes, relationships, cardinality (1:1, 1:M, M:M) |
| 3 | Basic | Keys | Primary, composite, surrogate vs natural keys |
| 4 | Basic | Normalization | 1NF, 2NF, 3NF |
| 5 | Intermediate | OLTP vs OLAP | Differences, use cases, design goals |
| 6 | Intermediate | Denormalization | When and why to denormalize for analytics |
| 7 | Intermediate | Dimensional Modeling | Star vs snowflake schema |
| 8 | Advanced | Lakehouse Modeling | Medallion architecture: Bronze/Silver/Gold |
| 9 | Advanced | Unity Catalog Modeling | Metastore > Catalog > Schema > Table |
| 10 | Advanced | Data Vault (Intro) | Hubs, links, satellites |
| 11 | Advanced | Performance-aware Modeling | Partitioning keys, Z-order/clustering, file sizing |

### 3.2 Hands-on Projects

**Project 1: ER Diagram & Normalization for an Orders System**
- Gathered requirements for Customers, Orders, Products and OrderItems.
- Drew an ER diagram with cardinalities.
- Normalized the design to 3NF and defined primary/foreign keys for each table.
- Deliverable: ER diagram, table DDL and a short write-up.
- Image:
  <img width="986" height="1583" alt="My First Board" src="https://github.com/user-attachments/assets/e3bec2b8-3c86-4a53-8f81-7ba7b7050da1" />
