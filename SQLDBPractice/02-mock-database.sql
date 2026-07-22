-- ============================================================
-- SQL MOCK DATABASE - Microsoft SQL Server (T-SQL)
-- ============================================================

-- Create and switch to a dedicated database (keeps master clean)
IF DB_ID('SqlPractice') IS NULL
    CREATE DATABASE SqlPractice;
GO
USE SqlPractice;
GO

-- Drop tables if they exist (FK-safe order: children first)
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS departments;
GO

-- ===================== SCHEMA =====================
CREATE TABLE departments (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    budget DECIMAL(12,2),
    location VARCHAR(100),
    created_at DATE
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    department_id INT,
    manager_id INT,
    job_title VARCHAR(100),
    is_active BIT DEFAULT 1,
    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (manager_id) REFERENCES employees(id)
);

CREATE TABLE customers (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(50) DEFAULT 'USA',
    registration_date DATE,
    is_premium BIT DEFAULT 0
);

CREATE TABLE categories (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(MAX),
    parent_category_id INT,
    FOREIGN KEY (parent_category_id) REFERENCES categories(id)
);

CREATE TABLE suppliers (
    id INT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(100),
    country VARCHAR(50),
    rating DECIMAL(2,1)
);

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT,
    supplier_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    weight_kg DECIMAL(5,2),
    is_available BIT DEFAULT 1,
    created_at DATE,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    shipped_date DATE,
    status VARCHAR(20) DEFAULT 'pending',
    total DECIMAL(10,2),
    shipping_city VARCHAR(100),
    shipping_country VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE order_items (
    id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(4,2) DEFAULT 0.00,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE reviews (
    id INT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review_text VARCHAR(MAX),
    review_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);
GO

-- ===================== DATA =====================
INSERT INTO departments (id, name, budget, location, created_at) VALUES
(1, 'Engineering', 2500000.00, 'San Francisco', '2018-01-15'),
(2, 'Marketing', 1200000.00, 'New York', '2018-03-01'),
(3, 'Sales', 1800000.00, 'Chicago', '2018-02-10'),
(4, 'Human Resources', 800000.00, 'San Francisco', '2018-01-15'),
(5, 'Finance', 950000.00, 'New York', '2018-04-20'),
(6, 'Customer Support', 650000.00, 'Austin', '2019-06-01'),
(7, 'Product', 1500000.00, 'San Francisco', '2018-05-10'),
(8, 'Operations', 700000.00, 'Chicago', '2019-01-08');

INSERT INTO employees (id, first_name, last_name, email, phone, hire_date, salary, department_id, manager_id, job_title, is_active) VALUES
(1, 'James', 'Anderson', 'james.anderson@company.com', '555-0101', '2018-01-20', 155000.00, 1, NULL, 'VP of Engineering', 1),
(2, 'Sarah', 'Mitchell', 'sarah.mitchell@company.com', '555-0102', '2018-03-15', 135000.00, 2, NULL, 'VP of Marketing', 1),
(3, 'Robert', 'Chen', 'robert.chen@company.com', '555-0103', '2018-02-12', 140000.00, 3, NULL, 'VP of Sales', 1),
(4, 'Emily', 'Davis', 'emily.davis@company.com', '555-0104', '2018-06-01', 125000.00, 4, NULL, 'HR Director', 1),
(5, 'Michael', 'Torres', 'michael.torres@company.com', '555-0105', '2018-04-25', 130000.00, 5, NULL, 'CFO', 1),
(6, 'Lisa', 'Wang', 'lisa.wang@company.com', '555-0106', '2018-09-10', 145000.00, 7, NULL, 'VP of Product', 1),
(7, 'David', 'Kim', 'david.kim@company.com', '555-0107', '2019-01-15', 120000.00, 1, 1, 'Senior Engineer', 1),
(8, 'Jennifer', 'Lopez', 'jennifer.lopez@company.com', '555-0108', '2019-02-20', 115000.00, 1, 1, 'Senior Engineer', 1),
(9, 'Alex', 'Johnson', 'alex.johnson@company.com', '555-0109', '2019-04-01', 95000.00, 1, 7, 'Software Engineer', 1),
(10, 'Maria', 'Garcia', 'maria.garcia@company.com', '555-0110', '2019-05-15', 92000.00, 1, 7, 'Software Engineer', 1),
(11, 'Chris', 'Brown', 'chris.brown@company.com', '555-0111', '2019-07-01', 88000.00, 1, 8, 'Junior Engineer', 1),
(12, 'Amanda', 'Wilson', 'amanda.wilson@company.com', '555-0112', '2020-01-10', 85000.00, 1, 8, 'Junior Engineer', 1),
(13, 'Daniel', 'Lee', 'daniel.lee@company.com', '555-0113', '2019-03-20', 98000.00, 2, 2, 'Marketing Manager', 1),
(14, 'Rachel', 'Taylor', 'rachel.taylor@company.com', '555-0114', '2019-08-15', 75000.00, 2, 13, 'Content Specialist', 1),
(15, 'Kevin', 'White', 'kevin.white@company.com', '555-0115', '2020-02-01', 72000.00, 2, 13, 'SEO Analyst', 1),
(16, 'Nicole', 'Harris', 'nicole.harris@company.com', '555-0116', '2020-06-10', 70000.00, 2, 13, 'Social Media Manager', 1),
(17, 'Brian', 'Clark', 'brian.clark@company.com', '555-0117', '2019-02-28', 105000.00, 3, 3, 'Sales Manager', 1),
(18, 'Stephanie', 'Lewis', 'stephanie.lewis@company.com', '555-0118', '2019-06-15', 82000.00, 3, 17, 'Account Executive', 1),
(19, 'Mark', 'Robinson', 'mark.robinson@company.com', '555-0119', '2019-09-01', 78000.00, 3, 17, 'Account Executive', 1),
(20, 'Laura', 'Walker', 'laura.walker@company.com', '555-0120', '2020-03-15', 65000.00, 3, 17, 'Sales Rep', 1),
(21, 'Tom', 'Hall', 'tom.hall@company.com', '555-0121', '2020-01-20', 68000.00, 3, 17, 'Sales Rep', 1),
(22, 'Jessica', 'Allen', 'jessica.allen@company.com', '555-0122', '2019-04-10', 85000.00, 4, 4, 'HR Manager', 1),
(23, 'Ryan', 'Young', 'ryan.young@company.com', '555-0123', '2020-07-01', 62000.00, 4, 22, 'HR Coordinator', 1),
(24, 'Michelle', 'King', 'michelle.king@company.com', '555-0124', '2019-05-20', 95000.00, 5, 5, 'Senior Accountant', 1),
(25, 'Andrew', 'Wright', 'andrew.wright@company.com', '555-0125', '2020-02-15', 78000.00, 5, 24, 'Accountant', 1),
(26, 'Samantha', 'Scott', 'samantha.scott@company.com', '555-0126', '2020-09-01', 72000.00, 5, 24, 'Financial Analyst', 1),
(27, 'Jason', 'Green', 'jason.green@company.com', '555-0127', '2019-08-10', 88000.00, 6, NULL, 'Support Manager', 1),
(28, 'Megan', 'Adams', 'megan.adams@company.com', '555-0128', '2020-01-05', 55000.00, 6, 27, 'Support Agent', 1),
(29, 'Tyler', 'Baker', 'tyler.baker@company.com', '555-0129', '2020-04-20', 54000.00, 6, 27, 'Support Agent', 1),
(30, 'Ashley', 'Nelson', 'ashley.nelson@company.com', '555-0130', '2020-08-15', 52000.00, 6, 27, 'Support Agent', 0),
(31, 'Brandon', 'Carter', 'brandon.carter@company.com', '555-0131', '2019-10-01', 110000.00, 7, 6, 'Product Manager', 1),
(32, 'Olivia', 'Mitchell', 'olivia.mitchell@company.com', '555-0132', '2020-03-10', 95000.00, 7, 6, 'Product Designer', 1),
(33, 'Nathan', 'Perez', 'nathan.perez@company.com', '555-0133', '2020-05-25', 88000.00, 7, 31, 'UX Researcher', 1),
(34, 'Victoria', 'Roberts', 'victoria.roberts@company.com', '555-0134', '2019-11-15', 82000.00, 8, NULL, 'Operations Manager', 1),
(35, 'Patrick', 'Turner', 'patrick.turner@company.com', '555-0135', '2020-06-01', 65000.00, 8, 34, 'Operations Analyst', 1),
(36, 'Christina', 'Phillips', 'christina.phillips@company.com', '555-0136', '2021-01-10', 90000.00, 1, 7, 'Software Engineer', 1),
(37, 'Derek', 'Campbell', 'derek.campbell@company.com', '555-0137', '2021-03-15', 87000.00, 1, 8, 'Software Engineer', 1),
(38, 'Hannah', 'Parker', 'hannah.parker@company.com', '555-0138', '2021-06-01', 58000.00, 6, 27, 'Support Agent', 1),
(39, 'Justin', 'Evans', 'justin.evans@company.com', '555-0139', '2021-02-20', 75000.00, 3, 17, 'Sales Rep', 0),
(40, 'Amber', 'Edwards', 'amber.edwards@company.com', '555-0140', '2021-04-10', 68000.00, 2, 13, 'Marketing Coordinator', 1);

INSERT INTO customers (id, first_name, last_name, email, phone, city, state, country, registration_date, is_premium) VALUES
(1, 'John', 'Smith', 'john.smith@email.com', '555-1001', 'New York', 'NY', 'USA', '2020-01-15', 1),
(2, 'Emma', 'Johnson', 'emma.j@email.com', '555-1002', 'Los Angeles', 'CA', 'USA', '2020-02-20', 1),
(3, 'William', 'Brown', 'will.brown@email.com', '555-1003', 'Chicago', 'IL', 'USA', '2020-03-10', 0),
(4, 'Sophia', 'Williams', 'sophia.w@email.com', '555-1004', 'Houston', 'TX', 'USA', '2020-04-05', 1),
(5, 'Oliver', 'Jones', 'oliver.jones@email.com', '555-1005', 'Phoenix', 'AZ', 'USA', '2020-05-12', 0),
(6, 'Ava', 'Garcia', 'ava.garcia@email.com', '555-1006', 'San Antonio', 'TX', 'USA', '2020-06-18', 0),
(7, 'Liam', 'Miller', 'liam.m@email.com', '555-1007', 'San Diego', 'CA', 'USA', '2020-07-22', 1),
(8, 'Isabella', 'Davis', 'isabella.d@email.com', '555-1008', 'Dallas', 'TX', 'USA', '2020-08-30', 0),
(9, 'Noah', 'Rodriguez', 'noah.r@email.com', '555-1009', 'San Jose', 'CA', 'USA', '2020-09-14', 1),
(10, 'Mia', 'Martinez', 'mia.martinez@email.com', '555-1010', 'Austin', 'TX', 'USA', '2020-10-25', 0),
(11, 'Ethan', 'Hernandez', 'ethan.h@email.com', '555-1011', 'Seattle', 'WA', 'USA', '2020-11-08', 1),
(12, 'Charlotte', 'Lopez', 'charlotte.l@email.com', '555-1012', 'Denver', 'CO', 'USA', '2020-12-01', 0),
(13, 'Mason', 'Gonzalez', 'mason.g@email.com', '555-1013', 'Boston', 'MA', 'USA', '2021-01-10', 0),
(14, 'Amelia', 'Wilson', 'amelia.w@email.com', '555-1014', 'Portland', 'OR', 'USA', '2021-02-14', 1),
(15, 'Lucas', 'Anderson', 'lucas.a@email.com', '555-1015', 'Las Vegas', 'NV', 'USA', '2021-03-20', 0),
(16, 'Harper', 'Thomas', 'harper.t@email.com', '555-1016', 'Miami', 'FL', 'USA', '2021-04-05', 1),
(17, 'Logan', 'Taylor', 'logan.t@email.com', '555-1017', 'Atlanta', 'GA', 'USA', '2021-05-12', 0),
(18, 'Evelyn', 'Moore', 'evelyn.m@email.com', '555-1018', 'Minneapolis', 'MN', 'USA', '2021-06-18', 0),
(19, 'Alexander', 'Jackson', 'alex.jackson@email.com', '555-1019', 'Detroit', 'MI', 'USA', '2021-07-25', 1),
(20, 'Abigail', 'Martin', 'abigail.m@email.com', '555-1020', 'Nashville', 'TN', 'USA', '2021-08-30', 0),
(21, 'Henry', 'Lee', 'henry.lee@email.com', '555-1021', 'Baltimore', 'MD', 'USA', '2021-09-05', 0),
(22, 'Emily', 'Perez', 'emily.perez@email.com', '555-1022', 'Milwaukee', 'WI', 'USA', '2021-10-12', 1),
(23, 'Sebastian', 'Thompson', 'seb.t@email.com', '555-1023', 'Raleigh', 'NC', 'USA', '2021-11-20', 0),
(24, 'Ella', 'White', 'ella.white@email.com', '555-1024', 'Kansas City', 'MO', 'USA', '2021-12-01', 0),
(25, 'Jack', 'Harris', 'jack.harris@email.com', '555-1025', 'Tampa', 'FL', 'USA', '2022-01-08', 1),
(26, 'Scarlett', 'Sanchez', 'scarlett.s@email.com', '555-1026', 'Pittsburgh', 'PA', 'USA', '2022-02-14', 0),
(27, 'Aiden', 'Clark', 'aiden.clark@email.com', '555-1027', 'Cincinnati', 'OH', 'USA', '2022-03-22', 0),
(28, 'Grace', 'Ramirez', 'grace.r@email.com', '555-1028', 'Orlando', 'FL', 'USA', '2022-04-10', 1),
(29, 'Owen', 'Lewis', 'owen.lewis@email.com', '555-1029', 'Sacramento', 'CA', 'USA', '2022-05-18', 0),
(30, 'Chloe', 'Robinson', 'chloe.r@email.com', '555-1030', 'Cleveland', 'OH', 'USA', '2022-06-25', 0),
(31, 'Samuel', 'Walker', 'samuel.w@email.com', '555-1031', 'Toronto', 'ON', 'Canada', '2022-07-01', 1),
(32, 'Lily', 'Young', 'lily.young@email.com', '555-1032', 'Vancouver', 'BC', 'Canada', '2022-08-15', 0),
(33, 'Benjamin', 'Allen', 'ben.allen@email.com', '555-1033', 'London', NULL, 'UK', '2022-09-10', 1),
(34, 'Zoe', 'King', 'zoe.king@email.com', '555-1034', 'Manchester', NULL, 'UK', '2022-10-20', 0),
(35, 'James', 'Wright', 'james.wright@email.com', '555-1035', 'Sydney', NULL, 'Australia', '2022-11-05', 1),
(36, 'Penelope', 'Scott', 'penelope.s@email.com', '555-1036', 'Melbourne', NULL, 'Australia', '2022-12-12', 0),
(37, 'Carter', 'Torres', 'carter.t@email.com', '555-1037', 'Berlin', NULL, 'Germany', '2023-01-18', 0),
(38, 'Riley', 'Nguyen', 'riley.n@email.com', '555-1038', 'Paris', NULL, 'France', '2023-02-22', 1),
(39, 'Luke', 'Hill', 'luke.hill@email.com', '555-1039', 'Tokyo', NULL, 'Japan', '2023-03-30', 0),
(40, 'Nora', 'Flores', 'nora.flores@email.com', '555-1040', 'Mexico City', NULL, 'Mexico', '2023-04-15', 0),
(41, 'Gabriel', 'Green', 'gabriel.g@email.com', '555-1041', 'New York', 'NY', 'USA', '2023-05-20', 1),
(42, 'Aria', 'Adams', 'aria.adams@email.com', '555-1042', 'Chicago', 'IL', 'USA', '2023-06-10', 0),
(43, 'Julian', 'Nelson', 'julian.n@email.com', '555-1043', 'Houston', 'TX', 'USA', '2023-07-05', 0),
(44, 'Layla', 'Baker', 'layla.baker@email.com', '555-1044', 'Phoenix', 'AZ', 'USA', '2023-08-12', 1),
(45, 'Wyatt', 'Hall', 'wyatt.hall@email.com', '555-1045', 'San Francisco', 'CA', 'USA', '2023-09-18', 0),
(46, 'Hannah', 'Rivera', 'hannah.r@email.com', '555-1046', 'Seattle', 'WA', 'USA', '2023-10-25', 0),
(47, 'Leo', 'Campbell', 'leo.c@email.com', '555-1047', 'Denver', 'CO', 'USA', '2023-11-01', 1),
(48, 'Stella', 'Mitchell', 'stella.m@email.com', '555-1048', 'Boston', 'MA', 'USA', '2023-12-08', 0),
(49, 'Mateo', 'Carter', 'mateo.c@email.com', '555-1049', 'Austin', 'TX', 'USA', '2024-01-14', 0),
(50, 'Aurora', 'Phillips', 'aurora.p@email.com', NULL, 'Portland', 'OR', 'USA', '2024-02-20', 1);

INSERT INTO categories (id, name, description, parent_category_id) VALUES
(1, 'Electronics', 'Electronic devices and accessories', NULL),
(2, 'Computers', 'Laptops, desktops, and accessories', 1),
(3, 'Phones', 'Smartphones and accessories', 1),
(4, 'Audio', 'Headphones, speakers, and audio equipment', 1),
(5, 'Clothing', 'Apparel and fashion', NULL),
(6, 'Men''s Clothing', 'Men''s apparel', 5),
(7, 'Women''s Clothing', 'Women''s apparel', 5),
(8, 'Home & Garden', 'Home decor and garden supplies', NULL),
(9, 'Kitchen', 'Kitchen appliances and tools', 8),
(10, 'Books', 'Physical and digital books', NULL),
(11, 'Sports & Outdoors', 'Sporting goods and outdoor equipment', NULL),
(12, 'Toys & Games', 'Toys, games, and puzzles', NULL);

INSERT INTO suppliers (id, company_name, contact_name, email, phone, city, country, rating) VALUES
(1, 'TechWorld Inc', 'John Peters', 'john@techworld.com', '555-2001', 'Shenzhen', 'China', 4.5),
(2, 'FashionForward', 'Marie Claire', 'marie@fashionforward.com', '555-2002', 'Milan', 'Italy', 4.2),
(3, 'HomeEssentials Co', 'Bob Smith', 'bob@homeessentials.com', '555-2003', 'Chicago', 'USA', 3.8),
(4, 'BookHouse Publishers', 'Alice Reader', 'alice@bookhouse.com', '555-2004', 'London', 'UK', 4.7),
(5, 'SportsPro Supply', 'Mike Runner', 'mike@sportspro.com', '555-2005', 'Portland', 'USA', 4.0),
(6, 'GadgetZone', 'Li Wei', 'liwei@gadgetzone.com', '555-2006', 'Tokyo', 'Japan', 4.6),
(7, 'EcoHome Products', 'Sarah Green', 'sarah@ecohome.com', '555-2007', 'Stockholm', 'Sweden', 4.3),
(8, 'PlayTime Industries', 'Tom Fun', 'tom@playtime.com', '555-2008', 'Los Angeles', 'USA', 3.9),
(9, 'AudioMax', 'DJ Beats', 'dj@audiomax.com', '555-2009', 'Berlin', 'Germany', 4.4),
(10, 'GlobalTextiles', 'Raj Patel', 'raj@globaltextiles.com', '555-2010', 'Mumbai', 'India', 4.1);

INSERT INTO products (id, product_name, category_id, supplier_id, price, stock_quantity, weight_kg, is_available, created_at) VALUES
(1, 'Laptop Pro 15"', 2, 1, 1299.99, 45, 2.10, 1, '2021-03-15'),
(2, 'Laptop Air 13"', 2, 1, 999.99, 60, 1.40, 1, '2021-05-20'),
(3, 'Desktop Workstation', 2, 1, 1899.99, 20, 8.50, 1, '2021-08-10'),
(4, 'Smartphone X12', 3, 6, 899.99, 150, 0.19, 1, '2022-01-10'),
(5, 'Smartphone Lite', 3, 6, 499.99, 200, 0.17, 1, '2022-03-15'),
(6, 'Smartphone Pro Max', 3, 6, 1199.99, 80, 0.21, 1, '2022-09-01'),
(7, 'Wireless Headphones Elite', 4, 9, 349.99, 120, 0.28, 1, '2021-11-20'),
(8, 'Bluetooth Speaker', 4, 9, 129.99, 200, 0.75, 1, '2021-06-15'),
(9, 'Studio Monitor Headphones', 4, 9, 249.99, 75, 0.32, 1, '2022-02-28'),
(10, 'Noise Cancelling Earbuds', 4, 9, 199.99, 180, 0.05, 1, '2022-07-10'),
(11, 'Men''s Classic T-Shirt', 6, 10, 29.99, 500, 0.20, 1, '2021-01-05'),
(12, 'Men''s Slim Jeans', 6, 2, 79.99, 300, 0.60, 1, '2021-02-10'),
(13, 'Men''s Wool Blazer', 6, 2, 199.99, 100, 1.20, 1, '2021-04-20'),
(14, 'Women''s Summer Dress', 7, 2, 89.99, 250, 0.30, 1, '2021-05-01'),
(15, 'Women''s Leather Jacket', 7, 10, 249.99, 80, 1.80, 1, '2021-09-15'),
(16, 'Women''s Running Shoes', 7, 5, 119.99, 180, 0.65, 1, '2022-01-20'),
(17, 'Stainless Steel Cookware Set', 9, 3, 199.99, 90, 5.50, 1, '2021-03-01'),
(18, 'Coffee Machine Pro', 9, 3, 349.99, 55, 4.20, 1, '2021-07-10'),
(19, 'Blender Ultra', 9, 3, 89.99, 130, 2.80, 1, '2021-10-15'),
(20, 'Air Fryer XL', 9, 7, 149.99, 100, 5.00, 1, '2022-04-01'),
(21, 'The Great Novel', 10, 4, 14.99, 400, 0.35, 1, '2020-06-01'),
(22, 'SQL Mastery Guide', 10, 4, 49.99, 150, 0.55, 1, '2021-01-15'),
(23, 'Python Programming', 10, 4, 44.99, 180, 0.50, 1, '2021-04-10'),
(24, 'History of Everything', 10, 4, 24.99, 220, 0.70, 1, '2020-11-20'),
(25, 'Yoga Mat Premium', 11, 5, 39.99, 300, 1.20, 1, '2021-02-15'),
(26, 'Mountain Bike Pro', 11, 5, 899.99, 25, 12.50, 1, '2021-06-01'),
(27, 'Tennis Racket Carbon', 11, 5, 159.99, 65, 0.30, 1, '2021-08-20'),
(28, 'Camping Tent 4-Person', 11, 5, 249.99, 40, 3.80, 1, '2022-05-10'),
(29, 'Board Game Collection', 12, 8, 49.99, 200, 1.50, 1, '2021-11-01'),
(30, 'Building Blocks 1000pc', 12, 8, 34.99, 350, 1.20, 1, '2021-03-20'),
(31, 'RC Drone', 12, 8, 199.99, 60, 0.85, 1, '2022-02-14'),
(32, 'Puzzle 3000 Pieces', 12, 8, 29.99, 150, 1.00, 1, '2021-07-25'),
(33, 'Smart Watch Ultra', 1, 6, 399.99, 95, 0.05, 1, '2022-10-01'),
(34, 'Tablet Pro 11"', 1, 1, 799.99, 70, 0.47, 1, '2022-06-15'),
(35, 'Wireless Charger', 1, 6, 39.99, 400, 0.12, 1, '2022-01-05'),
(36, 'USB-C Hub 7-in-1', 2, 1, 59.99, 250, 0.15, 1, '2022-03-20'),
(37, 'Mechanical Keyboard', 2, 6, 149.99, 110, 0.90, 1, '2022-08-10'),
(38, 'Ergonomic Mouse', 2, 6, 79.99, 180, 0.12, 1, '2022-04-25'),
(39, 'Vintage Record Player', 4, 9, 299.99, 30, 4.50, 0, '2020-09-10'),
(40, 'Portable Power Bank', 1, 1, 49.99, 500, 0.25, 1, '2022-11-15');

INSERT INTO orders (id, customer_id, order_date, shipped_date, status, total, shipping_city, shipping_country) VALUES
(1, 1, '2022-01-05', '2022-01-08', 'delivered', 1349.98, 'New York', 'USA'),
(2, 2, '2022-01-12', '2022-01-15', 'delivered', 899.99, 'Los Angeles', 'USA'),
(3, 3, '2022-01-20', '2022-01-24', 'delivered', 159.98, 'Chicago', 'USA'),
(4, 4, '2022-02-01', '2022-02-04', 'delivered', 499.99, 'Houston', 'USA'),
(5, 5, '2022-02-10', NULL, 'cancelled', 249.99, 'Phoenix', 'USA'),
(6, 1, '2022-02-15', '2022-02-18', 'delivered', 349.99, 'New York', 'USA'),
(7, 6, '2022-03-01', '2022-03-05', 'delivered', 89.99, 'San Antonio', 'USA'),
(8, 7, '2022-03-10', '2022-03-13', 'delivered', 1199.99, 'San Diego', 'USA'),
(9, 8, '2022-03-20', '2022-03-24', 'delivered', 129.98, 'Dallas', 'USA'),
(10, 9, '2022-04-01', '2022-04-04', 'delivered', 949.98, 'San Jose', 'USA'),
(11, 10, '2022-04-12', '2022-04-16', 'delivered', 79.99, 'Austin', 'USA'),
(12, 2, '2022-04-20', '2022-04-23', 'delivered', 199.99, 'Los Angeles', 'USA'),
(13, 11, '2022-05-01', '2022-05-05', 'delivered', 1899.99, 'Seattle', 'USA'),
(14, 12, '2022-05-10', '2022-05-14', 'delivered', 349.99, 'Denver', 'USA'),
(15, 13, '2022-05-18', NULL, 'cancelled', 899.99, 'Boston', 'USA'),
(16, 14, '2022-06-01', '2022-06-04', 'delivered', 449.98, 'Portland', 'USA'),
(17, 15, '2022-06-10', '2022-06-14', 'delivered', 34.99, 'Las Vegas', 'USA'),
(18, 16, '2022-06-20', '2022-06-23', 'delivered', 629.98, 'Miami', 'USA'),
(19, 17, '2022-07-01', '2022-07-05', 'delivered', 199.99, 'Atlanta', 'USA'),
(20, 18, '2022-07-10', '2022-07-14', 'delivered', 89.99, 'Minneapolis', 'USA'),
(21, 19, '2022-07-20', '2022-07-23', 'delivered', 1299.99, 'Detroit', 'USA'),
(22, 20, '2022-08-01', '2022-08-05', 'delivered', 249.99, 'Nashville', 'USA'),
(23, 1, '2022-08-10', '2022-08-13', 'delivered', 499.99, 'New York', 'USA'),
(24, 21, '2022-08-20', '2022-08-24', 'delivered', 149.99, 'Baltimore', 'USA'),
(25, 22, '2022-09-01', '2022-09-04', 'delivered', 799.99, 'Milwaukee', 'USA'),
(26, 23, '2022-09-10', NULL, 'returned', 349.99, 'Raleigh', 'USA'),
(27, 24, '2022-09-20', '2022-09-23', 'delivered', 94.98, 'Kansas City', 'USA'),
(28, 25, '2022-10-01', '2022-10-04', 'delivered', 1549.98, 'Tampa', 'USA'),
(29, 4, '2022-10-10', '2022-10-14', 'delivered', 399.99, 'Houston', 'USA'),
(30, 7, '2022-10-20', '2022-10-23', 'delivered', 249.99, 'San Diego', 'USA'),
(31, 26, '2022-11-01', '2022-11-05', 'delivered', 179.98, 'Pittsburgh', 'USA'),
(32, 27, '2022-11-10', '2022-11-14', 'delivered', 49.99, 'Cincinnati', 'USA'),
(33, 28, '2022-11-20', '2022-11-23', 'delivered', 899.99, 'Orlando', 'USA'),
(34, 29, '2022-12-01', '2022-12-05', 'delivered', 129.99, 'Sacramento', 'USA'),
(35, 30, '2022-12-10', '2022-12-14', 'delivered', 59.98, 'Cleveland', 'USA'),
(36, 31, '2022-12-20', '2022-12-23', 'delivered', 1199.99, 'Toronto', 'Canada'),
(37, 32, '2023-01-05', '2023-01-09', 'delivered', 249.99, 'Vancouver', 'Canada'),
(38, 33, '2023-01-15', '2023-01-19', 'delivered', 449.98, 'London', 'UK'),
(39, 34, '2023-01-25', '2023-01-29', 'delivered', 79.99, 'Manchester', 'UK'),
(40, 35, '2023-02-05', '2023-02-09', 'delivered', 1699.98, 'Sydney', 'Australia'),
(41, 36, '2023-02-15', '2023-02-19', 'delivered', 89.99, 'Melbourne', 'Australia'),
(42, 37, '2023-02-25', '2023-03-01', 'delivered', 199.99, 'Berlin', 'Germany'),
(43, 38, '2023-03-05', '2023-03-09', 'delivered', 349.99, 'Paris', 'France'),
(44, 39, '2023-03-15', NULL, 'cancelled', 899.99, 'Tokyo', 'Japan'),
(45, 40, '2023-03-25', '2023-03-29', 'delivered', 149.99, 'Mexico City', 'Mexico'),
(46, 41, '2023-04-05', '2023-04-08', 'delivered', 999.99, 'New York', 'USA'),
(47, 42, '2023-04-15', '2023-04-19', 'delivered', 279.98, 'Chicago', 'USA'),
(48, 43, '2023-04-25', '2023-04-29', 'delivered', 49.99, 'Houston', 'USA'),
(49, 44, '2023-05-05', '2023-05-08', 'delivered', 1499.98, 'Phoenix', 'USA'),
(50, 45, '2023-05-15', '2023-05-19', 'delivered', 399.99, 'San Francisco', 'USA'),
(51, 46, '2023-05-25', '2023-05-29', 'delivered', 129.99, 'Seattle', 'USA'),
(52, 47, '2023-06-05', '2023-06-08', 'delivered', 849.98, 'Denver', 'USA'),
(53, 48, '2023-06-15', '2023-06-19', 'delivered', 94.98, 'Boston', 'USA'),
(54, 49, '2023-06-25', '2023-06-29', 'delivered', 199.99, 'Austin', 'USA'),
(55, 50, '2023-07-05', '2023-07-08', 'delivered', 1299.99, 'Portland', 'USA'),
(56, 1, '2023-07-15', '2023-07-18', 'delivered', 449.98, 'New York', 'USA'),
(57, 2, '2023-07-25', '2023-07-29', 'delivered', 799.99, 'Los Angeles', 'USA'),
(58, 9, '2023-08-05', '2023-08-08', 'delivered', 349.99, 'San Jose', 'USA'),
(59, 11, '2023-08-15', '2023-08-19', 'delivered', 599.98, 'Seattle', 'USA'),
(60, 14, '2023-08-25', '2023-08-29', 'delivered', 199.99, 'Portland', 'USA'),
(61, 16, '2023-09-05', '2023-09-08', 'delivered', 1199.99, 'Miami', 'USA'),
(62, 19, '2023-09-15', '2023-09-19', 'delivered', 449.98, 'Detroit', 'USA'),
(63, 22, '2023-09-25', '2023-09-29', 'delivered', 249.99, 'Milwaukee', 'USA'),
(64, 25, '2023-10-05', '2023-10-08', 'delivered', 899.99, 'Tampa', 'USA'),
(65, 28, '2023-10-15', '2023-10-19', 'delivered', 349.99, 'Orlando', 'USA'),
(66, 31, '2023-10-25', '2023-10-29', 'delivered', 199.99, 'Toronto', 'Canada'),
(67, 33, '2023-11-05', '2023-11-08', 'delivered', 1499.98, 'London', 'UK'),
(68, 35, '2023-11-15', '2023-11-19', 'delivered', 399.99, 'Sydney', 'Australia'),
(69, 38, '2023-11-25', NULL, 'processing', 599.98, 'Paris', 'France'),
(70, 41, '2023-12-05', '2023-12-08', 'delivered', 249.99, 'New York', 'USA'),
(71, 44, '2023-12-15', '2023-12-19', 'delivered', 1899.99, 'Phoenix', 'USA'),
(72, 47, '2023-12-25', '2023-12-29', 'delivered', 149.99, 'Denver', 'USA'),
(73, 50, '2024-01-05', '2024-01-08', 'delivered', 499.99, 'Portland', 'USA'),
(74, 1, '2024-01-15', '2024-01-18', 'delivered', 799.99, 'New York', 'USA'),
(75, 4, '2024-01-25', '2024-01-29', 'delivered', 349.99, 'Houston', 'USA'),
(76, 7, '2024-02-05', '2024-02-08', 'delivered', 1299.99, 'San Diego', 'USA'),
(77, 9, '2024-02-15', NULL, 'processing', 199.99, 'San Jose', 'USA'),
(78, 11, '2024-02-25', '2024-02-29', 'delivered', 449.98, 'Seattle', 'USA'),
(79, 16, '2024-03-05', '2024-03-08', 'delivered', 999.99, 'Miami', 'USA'),
(80, 25, '2024-03-15', NULL, 'pending', 649.98, 'Tampa', 'USA');

INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, discount) VALUES
(1, 1, 1, 1, 1299.99, 0.00),(2, 1, 35, 1, 39.99, 0.00),(3, 2, 4, 1, 899.99, 0.00),
(4, 3, 11, 2, 29.99, 0.00),(5, 3, 25, 1, 39.99, 0.00),(6, 3, 32, 1, 29.99, 0.00),
(7, 4, 5, 1, 499.99, 0.00),(8, 5, 15, 1, 249.99, 0.00),(9, 6, 7, 1, 349.99, 0.00),
(10, 7, 14, 1, 89.99, 0.00),(11, 8, 6, 1, 1199.99, 0.00),(12, 9, 8, 1, 129.99, 0.00),
(13, 10, 4, 1, 899.99, 0.00),(14, 10, 40, 1, 49.99, 0.00),(15, 11, 12, 1, 79.99, 0.00),
(16, 12, 17, 1, 199.99, 0.00),(17, 13, 3, 1, 1899.99, 0.00),(18, 14, 18, 1, 349.99, 0.00),
(19, 15, 26, 1, 899.99, 0.00),(20, 16, 9, 1, 249.99, 0.00),(21, 16, 10, 1, 199.99, 0.00),
(22, 17, 30, 1, 34.99, 0.00),(23, 18, 33, 1, 399.99, 0.10),(24, 18, 19, 1, 89.99, 0.00),
(25, 19, 13, 1, 199.99, 0.00),(26, 20, 19, 1, 89.99, 0.00),(27, 21, 1, 1, 1299.99, 0.00),
(28, 22, 28, 1, 249.99, 0.00),(29, 23, 5, 1, 499.99, 0.00),(30, 24, 20, 1, 149.99, 0.00),
(31, 25, 34, 1, 799.99, 0.00),(32, 26, 7, 1, 349.99, 0.00),(33, 27, 22, 1, 49.99, 0.00),
(34, 27, 23, 1, 44.99, 0.00),(35, 28, 1, 1, 1299.99, 0.05),(36, 28, 9, 1, 249.99, 0.00),
(37, 29, 33, 1, 399.99, 0.00),(38, 30, 15, 1, 249.99, 0.00),(39, 31, 37, 1, 149.99, 0.00),
(40, 31, 11, 1, 29.99, 0.00),(41, 32, 22, 1, 49.99, 0.00),(42, 33, 4, 1, 899.99, 0.00),
(43, 34, 8, 1, 129.99, 0.00),(44, 35, 25, 1, 39.99, 0.00),(45, 35, 11, 1, 29.99, 0.00),
(46, 36, 6, 1, 1199.99, 0.00),(47, 37, 28, 1, 249.99, 0.00),(48, 38, 33, 1, 399.99, 0.05),
(49, 38, 40, 1, 49.99, 0.00),(50, 39, 12, 1, 79.99, 0.00),(51, 40, 1, 1, 1299.99, 0.10),
(52, 40, 33, 1, 399.99, 0.00),(53, 41, 14, 1, 89.99, 0.00),(54, 42, 17, 1, 199.99, 0.00),
(55, 43, 7, 1, 349.99, 0.00),(56, 44, 4, 1, 899.99, 0.00),(57, 45, 20, 1, 149.99, 0.00),
(58, 46, 2, 1, 999.99, 0.00),(59, 47, 9, 1, 249.99, 0.00),(60, 47, 11, 1, 29.99, 0.00),
(61, 48, 22, 1, 49.99, 0.00),(62, 49, 6, 1, 1199.99, 0.10),(63, 49, 10, 1, 199.99, 0.00),
(64, 50, 33, 1, 399.99, 0.00),(65, 51, 8, 1, 129.99, 0.00),(66, 52, 34, 1, 799.99, 0.00),
(67, 52, 40, 1, 49.99, 0.00),(68, 53, 23, 1, 44.99, 0.00),(69, 53, 22, 1, 49.99, 0.00),
(70, 54, 13, 1, 199.99, 0.00),(71, 55, 1, 1, 1299.99, 0.00),(72, 56, 9, 1, 249.99, 0.00),
(73, 56, 10, 1, 199.99, 0.00),(74, 57, 34, 1, 799.99, 0.00),(75, 58, 7, 1, 349.99, 0.00),
(76, 59, 33, 1, 399.99, 0.00),(77, 59, 10, 1, 199.99, 0.00),(78, 60, 17, 1, 199.99, 0.00),
(79, 61, 6, 1, 1199.99, 0.00),(80, 62, 9, 1, 249.99, 0.00),(81, 62, 10, 1, 199.99, 0.00),
(82, 63, 15, 1, 249.99, 0.00),(83, 64, 4, 1, 899.99, 0.00),(84, 65, 18, 1, 349.99, 0.00),
(85, 66, 37, 1, 149.99, 0.00),(86, 66, 40, 1, 49.99, 0.00),(87, 67, 1, 1, 1299.99, 0.05),
(88, 67, 10, 1, 199.99, 0.00),(89, 68, 33, 1, 399.99, 0.00),(90, 69, 7, 1, 349.99, 0.00),
(91, 69, 9, 1, 249.99, 0.00),(92, 70, 28, 1, 249.99, 0.00),(93, 71, 3, 1, 1899.99, 0.00),
(94, 72, 20, 1, 149.99, 0.00),(95, 73, 5, 1, 499.99, 0.00),(96, 74, 34, 1, 799.99, 0.00),
(97, 75, 7, 1, 349.99, 0.00),(98, 76, 1, 1, 1299.99, 0.00),(99, 77, 17, 1, 199.99, 0.00),
(100, 78, 9, 1, 249.99, 0.00),(101, 78, 10, 1, 199.99, 0.00),(102, 79, 2, 1, 999.99, 0.00),
(103, 80, 18, 1, 349.99, 0.00),(104, 80, 19, 1, 89.99, 0.00),(105, 80, 37, 1, 149.99, 0.05),
(106, 1, 40, 1, 49.99, 0.10),(107, 4, 35, 2, 39.99, 0.00),(108, 10, 35, 1, 39.99, 0.00),
(109, 18, 35, 2, 39.99, 0.15),(110, 28, 40, 2, 49.99, 0.00),(111, 40, 35, 2, 39.99, 0.00),
(112, 49, 35, 2, 39.99, 0.05),(113, 56, 35, 1, 39.99, 0.00),(114, 67, 35, 1, 39.99, 0.00),
(115, 74, 35, 1, 39.99, 0.00),(116, 3, 21, 2, 14.99, 0.00),(117, 9, 21, 1, 14.99, 0.00),
(118, 35, 21, 1, 14.99, 0.00),(119, 53, 21, 1, 14.99, 0.00),(120, 80, 21, 3, 14.99, 0.10);

INSERT INTO reviews (id, product_id, customer_id, rating, review_text, review_date) VALUES
(1, 1, 1, 5, 'Absolutely amazing laptop! Fast, sleek, and reliable.', '2022-01-20'),
(2, 1, 19, 4, 'Great performance but battery could be better.', '2022-08-05'),
(3, 1, 33, 5, 'Best laptop I have ever owned. Worth every penny.', '2023-02-01'),
(4, 4, 2, 4, 'Great phone with excellent camera. Slightly overpriced.', '2022-01-25'),
(5, 4, 9, 5, 'Love this phone! The display is incredible.', '2022-04-15'),
(6, 4, 25, 4, 'Solid phone. Fast charging is a game changer.', '2022-10-20'),
(7, 5, 4, 3, 'Decent for the price but feels cheap. Camera is okay.', '2022-02-15'),
(8, 5, 23, 4, 'Good budget option. Does everything I need.', '2022-09-25'),
(9, 6, 8, 5, 'The best smartphone on the market. Period.', '2022-03-30'),
(10, 6, 16, 5, 'Incredible screen and performance. No complaints.', '2022-07-05'),
(11, 7, 1, 5, 'Noise cancellation is superb. Very comfortable.', '2022-03-01'),
(12, 7, 38, 4, 'Great headphones. Sound quality is top-notch.', '2023-03-20'),
(13, 7, 47, 4, 'Comfortable for long sessions. Bass could be deeper.', '2023-12-30'),
(14, 8, 9, 3, 'Good speaker for the price. Not very loud though.', '2022-04-10'),
(15, 8, 34, 4, 'Decent bluetooth speaker. Battery life is great.', '2023-02-05'),
(16, 9, 14, 5, 'Perfect for music production. Crystal clear sound.', '2022-06-15'),
(17, 10, 16, 4, 'Great earbuds. Noise cancelling works well.', '2022-07-10'),
(18, 10, 44, 5, 'Best earbuds I have ever had. Fits perfectly.', '2023-05-20'),
(19, 11, 3, 4, 'Good quality cotton. Fits well. Will buy more.', '2022-02-01'),
(20, 11, 42, 3, 'Basic tee. Nothing special but comfortable.', '2023-05-01'),
(21, 12, 11, 4, 'Nice fit. Material is durable.', '2022-05-10'),
(22, 13, 19, 5, 'Elegant blazer. Gets compliments every time.', '2022-08-01'),
(23, 14, 7, 4, 'Beautiful dress. Colors are vibrant.', '2022-03-15'),
(24, 14, 36, 3, 'Nice but runs a bit small. Order size up.', '2023-02-20'),
(25, 15, 22, 5, 'High quality leather. Looks amazing.', '2022-09-10'),
(26, 15, 30, 4, 'Great jacket but heavy. Not for warm weather.', '2022-12-15'),
(27, 16, 10, 4, 'Comfortable running shoes. Good support.', '2022-04-20'),
(28, 17, 12, 5, 'Excellent cookware. Heats evenly.', '2022-05-20'),
(29, 17, 48, 4, 'Good set. Handles are sturdy.', '2023-09-01'),
(30, 18, 14, 5, 'Makes barista quality coffee at home.', '2022-06-20'),
(31, 18, 28, 4, 'Great coffee machine. Espresso is perfect.', '2022-11-25'),
(32, 19, 7, 3, 'Works fine but is very loud.', '2022-03-20'),
(33, 19, 20, 4, 'Blends everything smoothly. Easy to clean.', '2022-08-10'),
(34, 20, 24, 4, 'Love the air fryer. Food comes out crispy.', '2022-09-01'),
(35, 20, 45, 5, 'Best kitchen purchase ever. Use it daily.', '2023-06-01'),
(36, 22, 13, 5, 'Comprehensive SQL guide. Learned so much.', '2022-05-25'),
(37, 22, 27, 4, 'Good reference book. Examples are practical.', '2022-11-15'),
(38, 22, 48, 5, 'Must-have for anyone learning databases.', '2023-07-01'),
(39, 23, 18, 4, 'Good intro to Python. Clear explanations.', '2022-07-15'),
(40, 23, 32, 4, 'Helpful for beginners. Could use more exercises.', '2023-01-12'),
(41, 25, 5, 4, 'Great yoga mat. Non-slip surface works well.', '2022-02-20'),
(42, 25, 46, 3, 'Decent mat. Wish it was thicker.', '2023-06-05'),
(43, 26, 15, 5, 'Incredible bike. Smooth ride on all terrain.', '2022-06-25'),
(44, 27, 17, 4, 'Good racket. Nice balance of power and control.', '2022-07-08'),
(45, 28, 20, 5, 'Spacious tent. Easy to set up. Waterproof.', '2022-08-15'),
(46, 28, 37, 4, 'Good for camping. Slight issue with zippers.', '2023-03-05'),
(47, 29, 3, 5, 'Fun for the whole family. Great variety of games.', '2022-01-30'),
(48, 30, 6, 4, 'Kids love it. Good quality blocks.', '2022-03-10'),
(49, 31, 29, 4, 'Cool drone. Camera quality is impressive.', '2022-12-10'),
(50, 33, 10, 5, 'Best smart watch on the market. Love the fitness tracking.', '2022-10-30'),
(51, 33, 35, 4, 'Great watch. Battery lasts about 2 days.', '2023-02-15'),
(52, 33, 41, 5, 'Sleek design. Health features are accurate.', '2023-04-15'),
(53, 34, 22, 4, 'Good tablet. Screen is beautiful.', '2022-09-15'),
(54, 34, 45, 5, 'Perfect for drawing and note-taking.', '2023-05-25'),
(55, 37, 26, 5, 'Best keyboard ever. Typing is so satisfying.', '2022-11-10'),
(56, 37, 31, 4, 'Great build quality. Loud clicks though.', '2022-12-25'),
(57, 38, 11, 4, 'Very comfortable mouse. No more wrist pain.', '2022-05-15'),
(58, 38, 42, 5, 'Perfect ergonomic design. Smooth scrolling.', '2023-04-20'),
(59, 40, 1, 4, 'Good capacity. Charges phone twice.', '2022-01-25'),
(60, 40, 9, 3, 'Decent power bank. Slow charging speed.', '2022-04-15');
GO

-- Quick check: confirm row counts
SELECT 'departments' AS table_name, COUNT(*) AS rows FROM departments
UNION ALL SELECT 'employees', COUNT(*) FROM employees
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews;
