-- 1 --
SELECT DISTINCT open_emp_id
FROM account
WHERE open_emp_id IS NOT NULL;
-- 2 --
SELECT account_id, cust_id, avail_balance
FROM account
WHERE status = 'ACTIVE'
	AND avail_balance >2500;
-- 3 --
SELECT dept_id, MIN(start_date) AS data_mais_antiga
FROM employee
GROUP BY dept_id;
-- 4 --
SELECT emp_id, fname, lname
FROM employee
ORDER BY fname ASC, lname ASC;
-- 5 -- 
SELECT fname, lname
FROM individual
UNION
SELECT fname, lname
FROM employee;
-- 6 --
SELECT emp_id
FROM employee
INTERSECT
SELECT superior_emp_id
FROM employee
WHERE superior_emp_id IS NOT NULL;
-- 7 --
SELECT city
FROM customer
EXCEPT
SELECT city
FROM branch;


