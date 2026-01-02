
DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
		Book_ID SERIAL PRIMARY KEY,
		Title VARCHAR(100),
		Author VARCHAR(100),
		Genre VARCHAR(50),
		Published_Year INT,
		Price NUMERIC(10,2),
		Stock INT
);

DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
		Customer_ID SERIAL PRIMARY KEY,
		Name VARCHAR(100),
		Email VARCHAR(100),
		Phone VARCHAR(15),
		City VARCHAR(50),
		Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
		Order_ID SERIAL PRIMARY KEY,
		Customer_ID INT REFERENCES Customers(Customer_ID),
		Book_ID INT REFERENCES Books(Book_ID),
		Order_Date DATE,
		Quantity INT,
		Total_Amount Numeric(10,2)
		
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year,Price, Stock)
FROM 'D:\SQL\SQL_PROJECT1\Books.csv'
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'D:\SQL\SQL_PROJECT1\Customers.csv'
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'D:\SQL\SQL_PROJECT1\Orders.csv'
CSV HEADER;

--Q.1 Retrieve all books in the fiction Genre
SELECT * FROM Books
WHERE Genre = 'Fiction';

--Q.2 Find Books published after year 1950
SELECT * FROM Books
WHERE Published_Year >1950;

--Q.3 List all the customers from Canada
SELECT * FROM Customers
WHERE Country = 'Canada';

--Q.4 Show orders placed in November 2023
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

--Q.5 Retrieve the total stock of books available
SELECT SUM(Stock) AS total_Bookstock
FROM Books; 

-- Q.6 Find the details of most expensive books
SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

--Q.7 Show all customers who ordered more than 1 quantity of a book
SELECT Quantity, Customer_ID  FROM Orders  
WHERE Quantity > 1;

--Q.8 Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders
WHERE Total_Amount < 20.00;

--Q.9 List all geners available in the book table
SELECT DISTINCT Genre FROM Books;

--Q.10 Find the book with the lowest stock
SELECT * FROM Books 
ORDER BY Stock ASC LIMIT 1; 

--Q.11 Calculate the Total Revenue generated from all orders
SELECT SUM(Total_Amount) AS total_revenue
FROM Orders;

-- Advance Queries
-- Q.1 Retrieve the total number of books sold for each genre
SELECT b.Genre, SUM(o.Quantity) AS Total_books_Sold
FROM Books b
JOIN Orders o ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;

--Q.2 Find the average price of books in the "Fantasy" Genre
SELECT AVG(Price) AS Average_Price FROM Books 
WHERE Genre = 'Fantasy';

-- Q.3 List Customers who have placed at least 2 orders
SELECT c.customer_id, c.Name, COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o
  ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.Name
HAVING COUNT(o.order_id) >= 2;


SELECT customer_id, COUNT(Order_ID) AS order_count
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id) >= 2;

SELECT o.customer_id,c.name, COUNT(o.Order_ID) AS order_count
FROM Orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id,c.name 
HAVING COUNT(order_id) >= 2;

-- Q.4 Find the most frequently ordered Book
SELECT o.Book_ID,b.title, COUNT(o.Order_ID) AS order_count
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY o.Book_ID, b.title
ORDER BY order_count DESC;

SELECT o.book_id, b.title, COUNT(o.order_id) AS order_count
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY o.book_id, b.title
HAVING COUNT(o.order_id) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(order_id) AS cnt
        FROM orders
        GROUP BY book_id
    ) t
);

SELECT book_id, title, order_count
FROM (
    SELECT o.book_id,
           b.title,
           COUNT(o.order_id) AS order_count,
           MAX(COUNT(o.order_id)) OVER () AS max_count
    FROM orders o
    JOIN books b ON o.book_id = b.book_id
    GROUP BY o.book_id, b.title
) t
WHERE order_count = max_count;

--Q.5 Show the top 3 most expensive books 
SELECT title, genre, price
FROM Books ORDER BY Price DESC LIMIT 3;

--Q.6 Show the top 3 most expensive books of 'Fantasy Genre'
SELECT title, genre, price  FROM Books
WHERE Genre = 'Fantasy' ORDER BY Price DESC LIMIT 3;

--Q.7 Retrieve the total quantity of books sold by each author
SELECT * FROM orders
WHERE book_id = 1;

SELECT b.author, SUM(o.quantity) AS total_books_sold
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY author ORDER BY total_books_sold DESC;

--Q.8 List the cities where customers who spent over $30 are located
SELECT DISTINCT c.city, total_amount 
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 30 ORDER BY total_amount ASC;

--Q.9 Find the customers who spent the most on orders
SELECT c.name, SUM(o.total_amount) AS books_sold
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY books_sold DESC LIMIT 4;

--Q.10 Calculate the stock remaining after fulfilling all orders
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS sold_quantity,
b.stock-COALESCE(SUM(o.quantity),0) AS remaining_stock
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;
