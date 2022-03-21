SELECT "Customer" as note, concat(firstname,' ',lastname) as name, city, country  FROM customers
UNION
SELECT "Supplier" as note, contactname, city, country FROM suppliers -- so luong cot giong nhau va giong kieu du lieu
ORDER BY name -- sap xep cua ket qua sau khi union;

-- xem cong viec va phong hien tai cua nhan vien 101
SELECT employee_id, first_name, job_id, department_id FROM employees WHERE employee_id =101;
-- xem cong viec va phong trong qua khu cua nhan vien 101
SELECT employee_id, job_id, department_id FROM job_history WHERE employee_id =101;

-- xem cong viec va phong hien tai cua nhan vien 101
SELECT employee_id, first_name, job_id, department_id, 'hien tai' as note FROM employees WHERE employee_id =101
UNION
SELECT employee_id, '', job_id, department_id, 'qua khu' as note FROM job_history WHERE employee_id =101;

-- xem cong viec va phong hien tai cua nhan vien 101
SELECT employee_id, first_name, job_id, department_id, 'hien tai' as note FROM employees WHERE employee_id =101
UNION
SELECT h.employee_id, e.FIRST_NAME, h.job_id, h.department_id, 'qua khu' as note FROM job_history h JOIN employees e on h.EMPLOYEE_ID=e.EMPLOYEE_ID WHERE h.employee_id =101;

-- truy van co nhom
-- nhom theo phong va dem so nhan vien cua moi phong
SELECT DEPARTMENT_ID, count(*) as So_nhan_vien
FROM employees
WHERE DEPARTMENT_ID is not null
GROUP BY DEPARTMENT_ID
ORDER BY So_nhan_vien DESC;

-- truy van co nhom
-- nhom theo phong va dem so nhan vien cua moi phong
-- cho biet them ten phong va tong luong
SELECT e.DEPARTMENT_ID, d.DEPARTMENT_NAME, count(*) as So_nhan_vien, SUM(e.SALARY) AS Tong_luong
FROM employees e JOIN departments d on e.DEPARTMENT_ID=d.DEPARTMENT_ID
WHERE e.DEPARTMENT_ID is not null
GROUP BY e.DEPARTMENT_ID, d.DEPARTMENT_NAME
ORDER BY So_nhan_vien DESC;

-- PIVOT: xoay cac dong thanh cac cot
SELECT year(HIRE_DATE) as year_hd, count(*) as count_emp
FROM employees
GROUP BY year(HIRE_DATE);
-- xoay cac dong thanh cac cot
SELECT 
	SUM(CASE WHEN year(HIRE_DATE) = 2004 then 1 else 0 END) as "Nam 2004",
    SUM(CASE WHEN year(HIRE_DATE) = 2005 then 1 else 0 END) as "Nam 2005",
    SUM(CASE WHEN year(HIRE_DATE) = 2006 then 1 else 0 END) as "Nam 2006",
    SUM(CASE WHEN year(HIRE_DATE) = 2007 then 1 else 0 END) as "Nam 2007",
    SUM(CASE WHEN year(HIRE_DATE) = 2008 then 1 else 0 END) as "Nam 2008",
    count(*) AS "Tong"
FROM employees
WHERE year(HIRE_DATE) BETWEEN 2004 and 2008;

-- PIVOT: xoay cac dong thanh cac cot
SELECT year(HIRE_DATE) as year_hd, count(*) as count_emp
FROM employees
GROUP BY year(HIRE_DATE);
-- xoay cac dong thanh cac cot
SELECT 
	SUM(IF(year(HIRE_DATE) = 2004,1,0)) as "Nam 2004",
    SUM(IF(year(HIRE_DATE) = 2005,1,0)) as "Nam 2005",
    SUM(IF(year(HIRE_DATE) = 2006,1,0)) as "Nam 2006",
    SUM(IF(year(HIRE_DATE) = 2007,1,0)) as "Nam 2007",
    SUM(IF(year(HIRE_DATE) = 2008,1,0)) as "Nam 2008",
    count(*) AS "Tong"
FROM employees
WHERE year(HIRE_DATE) BETWEEN 2004 and 2008;

-- xoay cac dong thanh cac cot
SELECT 
	JOB_ID,
	SUM(IF(year(HIRE_DATE) = 2004,1,0)) as "Nam 2004",
    SUM(IF(year(HIRE_DATE) = 2005,1,0)) as "Nam 2005",
    SUM(IF(year(HIRE_DATE) = 2006,1,0)) as "Nam 2006",
    SUM(IF(year(HIRE_DATE) = 2007,1,0)) as "Nam 2007",
    SUM(IF(year(HIRE_DATE) = 2008,1,0)) as "Nam 2008",
    count(*) AS "Tong"
FROM employees
WHERE year(HIRE_DATE) BETWEEN 2004 and 2008
GROUP BY JOB_ID;

-- VIEW: bang ao
CREATE VIEW myview
AS
	SELECT employee_id, first_name, last_name, hire_date, department_id
    FROM employees;

-- SUA VIEW: bang ao
CREATE OR REPLACE VIEW myview
AS
	SELECT employee_id, first_name, last_name, commission_pct, hire_date, department_id
    FROM employees;


