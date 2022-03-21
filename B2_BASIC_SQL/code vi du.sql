-- cho biet cac vdv dat huy chuong vang trong tvh 2012
SELECT *
FROM medals
WHERE Year = 2012
AND Medal = "Gold"
ORDER BY Sport, Athlete;

-- cho biet cac nhan vien cua phong 80 va phong 90, sap tang theo ma phong
SELECT *
FROM employees
WHERE department_id = 80 or department_id = 90
ORDER BY department_id;

-- cho biet cac nhan vien cua phong 80 va phong 90, sap tang theo ma phong
SELECT *
FROM employees
WHERE department_id in (80,90)
ORDER BY department_id;

-- dinh dang du lieu hien thi
-- gop first name va last name,
-- dinh dang hire date: dd/mm/yyyy
-- dinh dang salary: $23,456.00
SELECT employee_id, 
concat(FIRST_name," ",last_name) as name, -- expression AS alias
date_format(hire_date,"%d/%m/%Y") as hiredate, 
concat("$",format(salary,2)) as sal
FROM employees
ORDER BY salary desc;

-- dinh dang du lieu hien thi
-- gop first name va last name,
-- dinh dang hire date: dd/mm/yyyy
-- dinh dang salary: $23,456.00
SELECT employee_id, 
    concat(FIRST_name," ",last_name) as name, -- expression AS alias
    date_format(hire_date,"%d/%m/%Y") as hiredate, 
    concat("$",format(salary,2)) as sal,
    salary + 500 as bonus
FROM employees
ORDER BY salary desc;

-- tinh toan du lieu...
SELECT COUNT(*), SUM(salary), min(salary),max(salary),AVG(salary)
FROM employees;

-- tinh toan du lieu...
SELECT COUNT(*), SUM(salary), min(salary),max(salary),AVG(salary), STDDEV(salary)
FROM employees
WHERE department_id = 50;

-- tong hop du lieu va tinh toan (group)
-- cho biet moi phong va co tong luong la bao nhieu?
SELECT department_id, sum(salary) as sum_sal
FROM employees
GROUP BY department_id
ORDER BY sum_sal DESC;

-- tong hop du lieu va tinh toan (group)
-- cho phong nao co tong luong lon nhat
SELECT department_id, sum(salary) as sum_sal
FROM employees
GROUP BY department_id
ORDER BY sum_sal DESC
LIMIT 1;

-- tong hop du lieu va tinh toan (group)
-- cho phong nao co tong luong lon nhat
SELECT department_id, sum(salary) as sum_sal, AVG(SALARY) as avg_sal, COUNT(*) as count_emp
FROM employees
WHERE department_id is not null
GROUP BY department_id
ORDER BY department_id;

-- tong hop du lieu va tinh toan (group)
-- cho phong nao co tong luong lon nhat
SELECT department_id, sum(salary) as sum_sal, AVG(SALARY) as avg_sal, COUNT(*) as count_emp
FROM employees
WHERE department_id is not null
GROUP BY department_id
HAVING COUNT(*) >= 20 -- dieu kien loc cho nhom (group)
ORDER BY department_id;

SELECT * FROM `country` WHERE CountryCode = "VIE";
SELECT * FROM country WHERE CountryCode LIKE "VI%" -- So sanh gan dung;

-- cho biet cac nhan vien co luong tu 5000 den 7000
SELECT *
FROM employees
WHERE SALARY >= 5000 and SALARY <=7000;

-- cho biet cac nhan vien co luong tu 5000 den 7000
SELECT *
FROM employees
WHERE SALARY BETWEEN 5000 and 7000;

-- cho biet cac don dat hang cua thang 8 nam 2012
SELECT *
FROM orders
WHERE Month(`OrderDate`) = 8 and Year(`OrderDate`)=2012
ORDER BY OrderDate DESC;

-- cho biet cac don dat hang cua thang 8 nam 2012
SELECT *
FROM orders
WHERE OrderDate BETWEEN "2012-08-01" AND "2012-08-31"
ORDER BY OrderDate DESC;

-- cho biet cac don dat hang cua thang 8 nam 2012
SELECT *
FROM orders
WHERE OrderDate BETWEEN "2012-08-01 00:00:00" AND "2012-08-31 23:59:59"
ORDER BY OrderDate DESC;

SELECT count(*), 
count(DEPARTMENT_ID) -- khi truyen them bieu thuc nay thi neu department_id = null thi khong dem
FROM employees;

SELECT count(*), 
count(DEPARTMENT_ID), -- khi truyen them bieu thuc nay thi neu department_id = null thi khong dem
COUNT(COMMISSION_PCT)
FROM employees;

SELECT DISTINCT DEPARTMENT_ID
FROM employees
ORDER BY DEPARTMENT_ID;

UPDATE employees 
SET FIRST_NAME = upper(FIRST_NAME), 
LAST_NAME = upper(LAST_NAME);

-- Bai tap 2.1
SELECT `empid` as `Ma nhan vien`,
concat(`firstname` ," ",`lastname`) as `Ho va ten`,
`title`as `Chuc danh`,
date_format(`hiredate`,"%d/%m/%Y") as `Ngay vao lam`
FROM employees;

-- liet ke cac nhan vien co ngay vao lam la thu bay
SELECT `empid` as `Ma nhan vien`,
concat(`firstname` ," ",`lastname`) as `Ho va ten`,
`title`as `Chuc danh`,
date_format(`hiredate`,"%d/%m/%Y") as `Ngay vao lam`
FROM employees
-- where weekday(`hiredate`) = 5
WHERE DAYOFWEEK(`hiredate`) = 7;

-- tim cac nhan vien co last_name bat dau la chu K
SELECT *
FROM employees
WHERE LAST_NAME LIKE "K%";

-- tim cac nhan vien co last_name bat dau la chu K, tiep theo la ky tu gi cung duoc, tiep theo la ky tu n va sau do la ky tu gi cung duoc
SELECT *
FROM employees
WHERE LAST_NAME LIKE "K_n%";

-- tim cac nhan vien co last_name ket thuc la ng, truoc do la ky tu gi cung duoc
SELECT *
FROM employees
WHERE LAST_NAME LIKE "%ng";

-- tim cac nhan vien co last_name co chu an
SELECT *
FROM employees
WHERE LAST_NAME LIKE "%an%";

-- cho biet nhan vien co luong nho nhat va lon nhat
(SELECT *
FROM employees
ORDER BY SALARY
LIMIT 1)
UNION
(SELECT *
FROM employees
ORDER BY SALARY DESC
LIMIT 1);

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME FROM employees WHERE EMPLOYEE_ID = 103
UNION
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME FROM employees WHERE EMPLOYEE_ID = 105;

SELECT CountryCode, count(*) as `So huy chuong`
FROM medals
WHERE Year = 2012 and CountryCode != "" -- khac empty (co nap vao, nhung là gia tri trong)
GROUP BY CountryCode;

SELECT CountryCode, count(*) as `SoHuyChuong`
FROM medals
WHERE Year = 2012 and CountryCode != "" -- khac empty (co nap vao, nhung là gia tri trong)
GROUP BY CountryCode
ORDER BY SoHuyChuong DESC
LIMIT 10;

-- trong tvh 2012, thong ke theo cac gender, dem so huy chuong vang
SELECT Gender, count(*) as `SoHuyChuongVang`
FROM medals
WHERE Year = 2012
and Medal = "Gold"
GROUP BY Gender
ORDER BY SoHuyChuongVang DESC;

-- trong tvh 2012, thong ke theo cac gender, dem so huy chuong vang
SELECT Gender, Medal, count(*) as `SoHuyChuongVang`
FROM medals
WHERE Year = 2012
GROUP BY Gender, Medal;

