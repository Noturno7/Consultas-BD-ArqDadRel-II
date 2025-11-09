-- ==========================================
-- BANCO DE DADOS: BDempresa2, AOP2
-- ==========================================

-- Removendo objetos antigos 
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
SET search_path TO public;



CREATE TYPE cust_type_enum AS ENUM ('I','B');
CREATE TYPE status_enum AS ENUM ('ACTIVE','CLOSED','FROZEN');
CREATE TYPE txn_type_enum AS ENUM ('DBT','CDT');



-- DEPARTMENT
CREATE TABLE department (
  dept_id SMALLSERIAL PRIMARY KEY,
  name VARCHAR(20) NOT NULL
);

-- BRANCH
CREATE TABLE branch (
  branch_id SMALLSERIAL PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  address VARCHAR(30),
  city VARCHAR(20),
  state VARCHAR(2),
  zip VARCHAR(12)
);

-- EMPLOYEE
CREATE TABLE employee (
  emp_id SMALLSERIAL PRIMARY KEY,
  fname VARCHAR(20) NOT NULL,
  lname VARCHAR(20) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  superior_emp_id SMALLINT,
  dept_id SMALLINT,
  title VARCHAR(20),
  assigned_branch_id SMALLINT,
  CONSTRAINT fk_e_emp_id FOREIGN KEY (superior_emp_id) REFERENCES employee (emp_id),
  CONSTRAINT fk_dept_id FOREIGN KEY (dept_id) REFERENCES department (dept_id),
  CONSTRAINT fk_e_branch_id FOREIGN KEY (assigned_branch_id) REFERENCES branch (branch_id)
);

-- PRODUCT_TYPE
CREATE TABLE product_type (
  product_type_cd VARCHAR(10) PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

-- PRODUCT
CREATE TABLE product (
  product_cd VARCHAR(10) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  product_type_cd VARCHAR(10) NOT NULL,
  date_offered DATE,
  date_retired DATE,
  CONSTRAINT fk_product_type_cd FOREIGN KEY (product_type_cd) REFERENCES product_type (product_type_cd)
);

-- CUSTOMER
CREATE TABLE customer (
  cust_id SERIAL PRIMARY KEY,
  fed_id VARCHAR(12) NOT NULL,
  cust_type_cd cust_type_enum NOT NULL,
  address VARCHAR(30),
  city VARCHAR(20),
  state VARCHAR(20),
  postal_code VARCHAR(10)
);

-- INDIVIDUAL
CREATE TABLE individual (
  cust_id INT PRIMARY KEY REFERENCES customer (cust_id),
  fname VARCHAR(30) NOT NULL,
  lname VARCHAR(30) NOT NULL,
  birth_date DATE
);

-- BUSINESS
CREATE TABLE business (
  cust_id INT PRIMARY KEY REFERENCES customer (cust_id),
  name VARCHAR(40) NOT NULL,
  state_id VARCHAR(10) NOT NULL,
  incorp_date DATE
);

-- OFFICER
CREATE TABLE officer (
  officer_id SMALLSERIAL PRIMARY KEY,
  cust_id INT NOT NULL REFERENCES business (cust_id),
  fname VARCHAR(30) NOT NULL,
  lname VARCHAR(30) NOT NULL,
  title VARCHAR(20),
  start_date DATE NOT NULL,
  end_date DATE
);

-- ACCOUNT
CREATE TABLE account (
  account_id SERIAL PRIMARY KEY,
  product_cd VARCHAR(10) NOT NULL REFERENCES product (product_cd),
  cust_id INT NOT NULL REFERENCES customer (cust_id),
  open_date DATE NOT NULL,
  close_date DATE,
  last_activity_date DATE,
  status status_enum,
  open_branch_id SMALLINT REFERENCES branch (branch_id),
  open_emp_id SMALLINT REFERENCES employee (emp_id),
  avail_balance NUMERIC(10,2),
  pending_balance NUMERIC(10,2)
);

-- TRANSACTION
CREATE TABLE transaction (
  txn_id SERIAL PRIMARY KEY,
  txn_date TIMESTAMP NOT NULL,
  account_id INT NOT NULL REFERENCES account (account_id),
  txn_type_cd txn_type_enum,
  amount NUMERIC(10,2) NOT NULL,
  teller_emp_id SMALLINT REFERENCES employee (emp_id),
  execution_branch_id SMALLINT REFERENCES branch (branch_id),
  funds_avail_date TIMESTAMP
);
-- ==========================================
-- 🏢 POPULAÇÃO DAS TABELAS DEPARTMENT, BRANCH E EMPLOYEE
-- ==========================================

-- department data
INSERT INTO department (name)
VALUES ('Operations'),
       ('Loans'),
       ('Administration');

-- branch data
INSERT INTO branch (name, address, city, state, zip)
VALUES 
 ('Headquarters', '3882 Main St.', 'Waltham', 'MA', '02451'),
 ('Woburn Branch', '422 Maple St.', 'Woburn', 'MA', '01801'),
 ('Quincy Branch', '125 Presidential Way', 'Quincy', 'MA', '02169'),
 ('So. NH Branch', '378 Maynard Ln.', 'Salem', 'NH', '03079');

-- employee data
INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
VALUES 
 ('Michael', 'Smith', '2001-06-22', (SELECT dept_id FROM department WHERE name = 'Administration'), 'President', (SELECT branch_id FROM branch WHERE name = 'Headquarters')),
 ('Susan', 'Barker', '2002-09-12', (SELECT dept_id FROM department WHERE name = 'Administration'), 'Vice President', (SELECT branch_id FROM branch WHERE name = 'Headquarters')),
 ('Robert', 'Tyler', '2000-02-09', (SELECT dept_id FROM department WHERE name = 'Administration'), 'Treasurer', (SELECT branch_id FROM branch WHERE name = 'Headquarters')),
 ('Susan', 'Hawthorne', '2002-04-24', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Operations Manager', (SELECT branch_id FROM branch WHERE name = 'Headquarters')),
 ('John', 'Gooding', '2003-11-14', (SELECT dept_id FROM department WHERE name = 'Loans'), 'Loan Manager', (SELECT branch_id FROM branch WHERE name = 'Headquarters')),
 ('Helen', 'Fleming', '2004-03-17', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Head Teller', (SELECT branch_id FROM branch WHERE name = 'Headquarters')),
 ('Chris', 'Tucker', '2004-09-15', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Teller', (SELECT branch_id FROM branch WHERE name = 'Headquarters')),
 ('Sarah', 'Parker', '2002-12-02', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Teller', (SELECT branch_id FROM branch WHERE name = 'Headquarters')),
 ('Jane', 'Grossman', '2002-05-03', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Teller', (SELECT branch_id FROM branch WHERE name = 'Headquarters')),
 ('Paula', 'Roberts', '2002-07-27', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Head Teller', (SELECT branch_id FROM branch WHERE name = 'Woburn Branch')),
 ('Thomas', 'Ziegler', '2000-10-23', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Teller', (SELECT branch_id FROM branch WHERE name = 'Woburn Branch')),
 ('Samantha', 'Jameson', '2003-01-08', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Teller', (SELECT branch_id FROM branch WHERE name = 'Woburn Branch')),
 ('John', 'Blake', '2000-05-11', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Head Teller', (SELECT branch_id FROM branch WHERE name = 'Quincy Branch')),
 ('Cindy', 'Mason', '2002-08-09', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Teller', (SELECT branch_id FROM branch WHERE name = 'Quincy Branch')),
 ('Frank', 'Portman', '2003-04-01', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Teller', (SELECT branch_id FROM branch WHERE name = 'Quincy Branch')),
 ('Theresa', 'Markham', '2001-03-15', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Head Teller', (SELECT branch_id FROM branch WHERE name = 'So. NH Branch')),
 ('Beth', 'Fowler', '2002-06-29', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Teller', (SELECT branch_id FROM branch WHERE name = 'So. NH Branch')),
 ('Rick', 'Tulman', '2002-12-12', (SELECT dept_id FROM department WHERE name = 'Operations'), 'Teller', (SELECT branch_id FROM branch WHERE name = 'So. NH Branch'));


CREATE TEMP TABLE emp_tmp AS
SELECT emp_id, fname, lname FROM employee;

UPDATE employee SET superior_emp_id = (SELECT emp_id FROM emp_tmp WHERE lname = 'Smith' AND fname = 'Michael')
WHERE (lname, fname) IN (('Barker','Susan'), ('Tyler','Robert'));

UPDATE employee SET superior_emp_id = (SELECT emp_id FROM emp_tmp WHERE lname = 'Tyler' AND fname = 'Robert')
WHERE lname = 'Hawthorne' AND fname = 'Susan';

UPDATE employee SET superior_emp_id = (SELECT emp_id FROM emp_tmp WHERE lname = 'Hawthorne' AND fname = 'Susan')
WHERE (lname, fname) IN (('Gooding','John'),('Fleming','Helen'),('Roberts','Paula'),('Blake','John'),('Markham','Theresa'));

UPDATE employee SET superior_emp_id = (SELECT emp_id FROM emp_tmp WHERE lname = 'Fleming' AND fname = 'Helen')
WHERE (lname, fname) IN (('Tucker','Chris'),('Parker','Sarah'),('Grossman','Jane'));

UPDATE employee SET superior_emp_id = (SELECT emp_id FROM emp_tmp WHERE lname = 'Roberts' AND fname = 'Paula')
WHERE (lname, fname) IN (('Ziegler','Thomas'),('Jameson','Samantha'));

UPDATE employee SET superior_emp_id = (SELECT emp_id FROM emp_tmp WHERE lname = 'Blake' AND fname = 'John')
WHERE (lname, fname) IN (('Mason','Cindy'),('Portman','Frank'));

UPDATE employee SET superior_emp_id = (SELECT emp_id FROM emp_tmp WHERE lname = 'Markham' AND fname = 'Theresa')
WHERE (lname, fname) IN (('Fowler','Beth'),('Tulman','Rick'));

DROP TABLE emp_tmp;

-- ==========================================
-- 👥 POPULAÇÃO DAS TABELAS CUSTOMER, INDIVIDUAL, BUSINESS, OFFICER
-- ==========================================

-- residential (individual) customers
INSERT INTO customer (fed_id, cust_type_cd, address, city, state, postal_code)
VALUES 
 ('111-11-1111', 'I', '47 Mockingbird Ln', 'Lynnfield', 'MA', '01940'),
 ('222-22-2222', 'I', '372 Clearwater Blvd', 'Woburn', 'MA', '01801'),
 ('333-33-3333', 'I', '18 Jessup Rd', 'Quincy', 'MA', '02169'),
 ('444-44-4444', 'I', '12 Buchanan Ln', 'Waltham', 'MA', '02451'),
 ('555-55-5555', 'I', '2341 Main St', 'Salem', 'NH', '03079'),
 ('666-66-6666', 'I', '12 Blaylock Ln', 'Waltham', 'MA', '02451'),
 ('777-77-7777', 'I', '29 Admiral Ln', 'Wilmington', 'MA', '01887'),
 ('888-88-8888', 'I', '472 Freedom Rd', 'Salem', 'NH', '03079'),
 ('999-99-9999', 'I', '29 Maple St', 'Newton', 'MA', '02458');

-- corresponding individual data
INSERT INTO individual (cust_id, fname, lname, birth_date)
SELECT cust_id, 'James', 'Hadley', '1972-04-22' FROM customer WHERE fed_id = '111-11-1111';
INSERT INTO individual (cust_id, fname, lname, birth_date)
SELECT cust_id, 'Susan', 'Tingley', '1968-08-15' FROM customer WHERE fed_id = '222-22-2222';
INSERT INTO individual (cust_id, fname, lname, birth_date)
SELECT cust_id, 'Frank', 'Tucker', '1958-02-06' FROM customer WHERE fed_id = '333-33-3333';
INSERT INTO individual (cust_id, fname, lname, birth_date)
SELECT cust_id, 'John', 'Hayward', '1966-12-22' FROM customer WHERE fed_id = '444-44-4444';
INSERT INTO individual (cust_id, fname, lname, birth_date)
SELECT cust_id, 'Charles', 'Frasier', '1971-08-25' FROM customer WHERE fed_id = '555-55-5555';
INSERT INTO individual (cust_id, fname, lname, birth_date)
SELECT cust_id, 'John', 'Spencer', '1962-09-14' FROM customer WHERE fed_id = '666-66-6666';
INSERT INTO individual (cust_id, fname, lname, birth_date)
SELECT cust_id, 'Margaret', 'Young', '1947-03-19' FROM customer WHERE fed_id = '777-77-7777';
INSERT INTO individual (cust_id, fname, lname, birth_date)
SELECT cust_id, 'Louis', 'Blake', '1977-07-01' FROM customer WHERE fed_id = '888-88-8888';
INSERT INTO individual (cust_id, fname, lname, birth_date)
SELECT cust_id, 'Richard', 'Farley', '1968-06-16' FROM customer WHERE fed_id = '999-99-9999';

-- ==========================================
-- corporate (business) customers
-- ==========================================
INSERT INTO customer (fed_id, cust_type_cd, address, city, state, postal_code)
VALUES 
 ('04-1111111', 'B', '7 Industrial Way', 'Salem', 'NH', '03079'),
 ('04-2222222', 'B', '287A Corporate Ave', 'Wilmington', 'MA', '01887'),
 ('04-3333333', 'B', '789 Main St', 'Salem', 'NH', '03079'),
 ('04-4444444', 'B', '4772 Presidential Way', 'Quincy', 'MA', '02169');

-- business data
INSERT INTO business (cust_id, name, state_id, incorp_date)
SELECT cust_id, 'Chilton Engineering', '12-345-678', '1995-05-01' FROM customer WHERE fed_id = '04-1111111';
INSERT INTO business (cust_id, name, state_id, incorp_date)
SELECT cust_id, 'Northeast Cooling Inc.', '23-456-789', '2001-01-01' FROM customer WHERE fed_id = '04-2222222';
INSERT INTO business (cust_id, name, state_id, incorp_date)
SELECT cust_id, 'Superior Auto Body', '34-567-890', '2002-06-30' FROM customer WHERE fed_id = '04-3333333';
INSERT INTO business (cust_id, name, state_id, incorp_date)
SELECT cust_id, 'AAA Insurance Inc.', '45-678-901', '1999-05-01' FROM customer WHERE fed_id = '04-4444444';

-- officer data
INSERT INTO officer (cust_id, fname, lname, title, start_date)
SELECT cust_id, 'John', 'Chilton', 'President', '1995-05-01' FROM customer WHERE fed_id = '04-1111111';
INSERT INTO officer (cust_id, fname, lname, title, start_date)
SELECT cust_id, 'Paul', 'Hardy', 'President', '2001-01-01' FROM customer WHERE fed_id = '04-2222222';
INSERT INTO officer (cust_id, fname, lname, title, start_date)
SELECT cust_id, 'Carl', 'Lutz', 'President', '2002-06-30' FROM customer WHERE fed_id = '04-3333333';
INSERT INTO officer (cust_id, fname, lname, title, start_date)
SELECT cust_id, 'Stanley', 'Cheswick', 'President', '1999-05-01' FROM customer WHERE fed_id = '04-4444444';

-- ==========================================
-- 💳 POPULAÇÃO DE PRODUTOS, CONTAS E TRANSAÇÕES
-- ==========================================

-- product type data
INSERT INTO product_type (product_type_cd, name)
VALUES 
 ('ACCOUNT','Customer Accounts'),
 ('LOAN','Individual and Business Loans'),
 ('INSURANCE','Insurance Offerings');

-- product data
INSERT INTO product (product_cd, name, product_type_cd, date_offered)
VALUES 
 ('CHK','checking account','ACCOUNT','2000-01-01'),
 ('SAV','savings account','ACCOUNT','2000-01-01'),
 ('MM','money market account','ACCOUNT','2000-01-01'),
 ('CD','certificate of deposit','ACCOUNT','2000-01-01'),
 ('MRT','home mortgage','LOAN','2000-01-01'),
 ('AUT','auto loan','LOAN','2000-01-01'),
 ('BUS','business line of credit','LOAN','2000-01-01'),
 ('SBL','small business loan','LOAN','2000-01-01');

-- ==========================================
-- RESIDENTIAL ACCOUNT DATA
-- ==========================================

-- James Hadley
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CHK', cust_id, '2000-01-15', '2005-01-04', 'ACTIVE',
       b.branch_id, e.emp_id, 1057.75, 1057.75
FROM customer c
JOIN branch b ON b.city = 'Woburn'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '111-11-1111'
LIMIT 1;
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'SAV', cust_id, '2000-01-15', '2004-12-19', 'ACTIVE',
       b.branch_id, e.emp_id, 500.00, 500.00
FROM customer c
JOIN branch b ON b.city = 'Woburn'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '111-11-1111'
LIMIT 1;
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CD', cust_id, '2004-06-30', '2004-06-30', 'ACTIVE',
       b.branch_id, e.emp_id, 3000.00, 3000.00
FROM customer c
JOIN branch b ON b.city = 'Woburn'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '111-11-1111'
LIMIT 1;

-- Susan Tingley
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CHK', cust_id, '2001-03-12', '2004-12-27', 'ACTIVE',
       b.branch_id, e.emp_id, 2258.02, 2258.02
FROM customer c
JOIN branch b ON b.city = 'Woburn'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '222-22-2222'
LIMIT 1;
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'SAV', cust_id, '2001-03-12', '2004-12-11', 'ACTIVE',
       b.branch_id, e.emp_id, 200.00, 200.00
FROM customer c
JOIN branch b ON b.city = 'Woburn'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '222-22-2222'
LIMIT 1;

-- Frank Tucker
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CHK', cust_id, '2002-11-23', '2004-11-30', 'ACTIVE',
       b.branch_id, e.emp_id, 1057.75, 1057.75
FROM customer c
JOIN branch b ON b.city = 'Quincy'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '333-33-3333'
LIMIT 1;
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'MM', cust_id, '2002-12-15', '2004-12-05', 'ACTIVE',
       b.branch_id, e.emp_id, 2212.50, 2212.50
FROM customer c
JOIN branch b ON b.city = 'Quincy'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '333-33-3333'
LIMIT 1;

-- John Hayward
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CHK', cust_id, '2003-09-12', '2005-01-03', 'ACTIVE',
       b.branch_id, e.emp_id, 534.12, 534.12
FROM customer c
JOIN branch b ON b.city = 'Waltham'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '444-44-4444'
LIMIT 1;

-- Charles Frasier
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CHK', cust_id, '2004-01-27', '2005-01-05', 'ACTIVE',
       b.branch_id, e.emp_id, 2237.97, 2897.97
FROM customer c
JOIN branch b ON b.city = 'Salem'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '555-55-5555'
LIMIT 1;

-- John Spencer
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CHK', cust_id, '2002-08-24', '2004-11-29', 'ACTIVE',
       b.branch_id, e.emp_id, 122.37, 122.37
FROM customer c
JOIN branch b ON b.city = 'Waltham'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '666-66-6666'
LIMIT 1;

-- Margaret Young
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CD', cust_id, '2004-01-12', '2004-01-12', 'ACTIVE',
       b.branch_id, e.emp_id, 5000.00, 5000.00
FROM customer c
JOIN branch b ON b.city = 'Woburn'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '777-77-7777'
LIMIT 1;

-- Louis Blake
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CHK', cust_id, '2001-05-23', '2005-01-03', 'ACTIVE',
       b.branch_id, e.emp_id, 3487.19, 3487.19
FROM customer c
JOIN branch b ON b.city = 'Salem'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '888-88-8888'
LIMIT 1;

-- Richard Farley
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CHK', cust_id, '2003-07-30', '2004-12-15', 'ACTIVE',
       b.branch_id, e.emp_id, 125.67, 125.67
FROM customer c
JOIN branch b ON b.city = 'Waltham'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '999-99-9999'
LIMIT 1;

-- ==========================================
-- BUSINESS ACCOUNT DATA
-- ==========================================

-- Chilton Engineering
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CHK', cust_id, '2002-09-30', '2004-12-15', 'ACTIVE',
       b.branch_id, e.emp_id, 23575.12, 23575.12
FROM customer c
JOIN branch b ON b.city = 'Salem'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '04-1111111'
LIMIT 1;

-- Northeast Cooling
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'BUS', cust_id, '2004-03-22', '2004-11-14', 'ACTIVE',
       b.branch_id, e.emp_id, 9345.55, 9345.55
FROM customer c
JOIN branch b ON b.city = 'Woburn'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '04-2222222'
LIMIT 1;

-- Superior Auto Body
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'CHK', cust_id, '2003-07-30', '2004-12-15', 'ACTIVE',
       b.branch_id, e.emp_id, 38552.05, 38552.05
FROM customer c
JOIN branch b ON b.city = 'Salem'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '04-3333333'
LIMIT 1;

-- AAA Insurance Inc.
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT 'SBL', cust_id, '2004-02-22', '2004-12-17', 'ACTIVE',
       b.branch_id, e.emp_id, 50000.00, 50000.00
FROM customer c
JOIN branch b ON b.city = 'Quincy'
JOIN employee e ON e.assigned_branch_id = b.branch_id
WHERE fed_id = '04-4444444'
LIMIT 1;

-- ==========================================
-- TRANSACTION DATA (DEPÓSITO INICIAL)
-- ==========================================

INSERT INTO transaction (txn_date, account_id, txn_type_cd, amount, funds_avail_date)
SELECT a.open_date, a.account_id, 'CDT', 100, a.open_date
FROM account a
WHERE a.product_cd IN ('CHK','SAV','CD','MM');


SELECT DISTINCT open_emp_id
FROM account
WHERE open_emp_id IS NOT NULL;




