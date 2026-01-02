# 📚 Online Bookstore Data Analysis | PostgreSQL

A comprehensive **SQL-based data analysis project** built on an **Online Bookstore database** using **PostgreSQL**.  
This project focuses on extracting actionable business insights related to sales performance, customer behavior, inventory management, and revenue trends using advanced SQL queries.

---

## 📌 Project Overview

The **Online Bookstore Data Analysis** project simulates a real-world bookstore system and demonstrates how SQL can be used to analyze transactional and operational data.

The analysis answers key business questions such as:
- Who are the top-spending customers?
- Which books generate the highest revenue?
- How much inventory remains after fulfilling all orders?
- What are the sales and demand trends across books and customers?

This project is ideal for:
- 📊 Data Analysts & SQL Developers  
- 🧠 Business Intelligence & Analytics Portfolios  
- 🏢 Retail & E-commerce Data Analysis Use Cases  

---

## 🛠️ Tech Stack

- 🐘 **PostgreSQL** – Primary relational database  
- 🧩 **pgAdmin 4** – SQL development and query execution  
- 🧠 **SQL** – Joins, aggregations, subqueries, CTEs, and business logic  
- 📁 **.sql** – Query scripts  

---

## 🗂️ Database Schema

The database consists of the following key tables:

- **books** – Book details, pricing, genre, and stock
- **customers** – Customer information
- **orders** – Transactional order data
- **users** – System users
- **employees / departments** – Organizational data (supporting tables)

Each table is connected using **primary and foreign key relationships**, enabling accurate joins and aggregations.

---

## 🎯 Business Problems Addressed

- Identifying **high-value customers**
- Measuring **total sales and revenue contribution**
- Monitoring **inventory levels after order fulfillment**
- Understanding **book demand and sales distribution**
- Supporting **data-driven inventory and marketing decisions**

---

## 📈 Key SQL Analyses & Queries

### 🔹 Top Customers by Total Spending
Identifies customers who have spent the most across all orders.

```sql
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 4;
