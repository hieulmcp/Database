-- thu tu: vang, bac, dong
SELECT countrycode, medal, count(*)
FROM medals
WHERE year = 2012 and countrycode != ""
GROUP BY countrycode, medal
ORDER BY countrycode, 
	CASE
    	WHEN medal = "Gold" THEN 1
        WHEN medal = "Silver" THEN 2
        ELSE 3
    END;

-- thong ke tong luong, tong so nhan vien theo 3 nhom luong
-- nhom 1: luong <=5000 --> luong thap
-- nhom 2: luong >5000 và <10000 --> luong vua
-- nhom 3: luong >10000 --> luong cao
SELECT 
	CASE
		WHEN `SALARY`<= 5000 then "Luong thap"
        WHEN `SALARY` < 10000 then "Luong vua"
        ELSE "Luong cao"
	END as Nhom
, COUNT(*) as SL_nhan_vien
FROM employees
GROUP BY Nhom;

-- thong ke cac quoc gia dat bao nhieu huy chuong van cua the van hoi 2012
-- ma quoc gia, dem so hcv
-- HD: group by, count
-- loc cac vdv cua tvh 2012
SELECT CountryCode, count(*) as so_hcv
FROM medals
WHERE Year = 2012 and Medal = "Gold" AND CountryCode != ""
GROUP BY CountryCode
ORDER BY so_hcv DESC;

-- thong ke cac quoc gia dat bao nhieu huy chuong van cua the van hoi 2012
-- ma quoc gia, dem so hcv
-- HD: group by, count
-- loc cac vdv cua tvh 2012
SELECT CountryCode, count(*) as so_hcv
FROM medals
WHERE Year = 2012 and Medal = "Gold" AND CountryCode != ""
GROUP BY CountryCode
HAVING so_hcv >= 30 -- dieu kien loc nhom
ORDER BY so_hcv DESC;

-- thong ke cac quoc gia dat bao nhieu huy chuong van cua the van hoi 2012
-- ma quoc gia, dem so hcv
-- HD: group by, count
-- loc cac vdv cua tvh 2012
SELECT * 
FROM
(
SELECT CountryCode, count(*) as so_hcv
FROM medals
WHERE Year = 2012 and Medal = "Gold" AND CountryCode != ""
GROUP BY CountryCode
) q
WHERE so_hcv >= 30
ORDER BY so_hcv DESC;

-- dem last_name cua cac nhan vien
-- last_name, so_nhan_vien
SELECT LAST_NAME, COUNT(*) as So_nhan_vien
FROM employees
GROUP BY LAST_NAME 
HAVING So_nhan_vien > 1
ORDER by So_nhan_vien DESC;

-- dem last_name cua cac nhan vien
-- last_name, so_nhan_vien
SELECT *
FROM employees
WHERE LAST_NAME IN
(
SELECT LAST_NAME
FROM employees
GROUP BY LAST_NAME 
HAVING COUNT(*) > 1)
ORDER by LAST_NAME;

SELECT 
SQRT(
    SUM(
        (SALARY - (SELECT AVG(SALARY) FROM employees)) * (SALARY - 			(SELECT AVG(SALARY) FROM employees)))
    / (SELECT COUNT(*) FROM employees))
FROM employees;

-- sub query tra ve 1: cho biet cac nhan vien co luong > luong cua nhan vien 105
SELECT SALARY FROM employees WHERE EMPLOYEE_ID=105;
SELECT *
FROM employees
WHERE SALARY > (SELECT SALARY FROM employees WHERE EMPLOYEE_ID=105);


-- sub query tra ve 1: cho biet cac nhan vien co luong > luong cua nhan vien co last_name là "King"
SELECT SALARY FROM employees WHERE LAST_NAME = "King";
SELECT *
FROM employees
WHERE SALARY > ALL(SELECT SALARY FROM employees WHERE LAST_NAME = "King") -- lon hon tat ca;
SELECT *
FROM employees
WHERE SALARY > ANY(SELECT SALARY FROM employees WHERE LAST_NAME = "King") -- lon hon bat ky;

-- cho biet cac nhan vien lam nhan vien quan ly
SELECT * 
FROM employees
WHERE EMPLOYEE_ID IN (SELECT DISTINCT MANAGER_ID FROM employees WHERE MANAGER_ID is not null);

-- cho biet cac phong chua co nhan vien
SELECT * 
FROM departments 
WHERE DEPARTMENT_ID not in 
(
SELECT DISTINCT `DEPARTMENT_ID`
FROM employees
WHERE `DEPARTMENT_ID` is not null
);

-- cho biet cac nhan vien co luong lon nhat
-- cho biet cac nhan vien cua phong 50 co luong lon nhat
SELECT * 
FROM employees
WHERE SALARY = (SELECT MAX(SALARY) FROM employees);
SELECT * 
FROM employees
WHERE SALARY = (SELECT MAX(SALARY) FROM employees WHERE DEPARTMENT_ID = 50) AND DEPARTMENT_ID = 50;

-- cho biet cac nhan vien co luong lon nhat
-- cho biet cac nhan vien cua phong 50 co luong lon nhat
SELECT * 
FROM employees
WHERE SALARY = (SELECT MAX(SALARY) FROM employees);
SELECT * 
FROM employees
WHERE SALARY = (SELECT MAX(SALARY) FROM employees WHERE DEPARTMENT_ID = 50) AND DEPARTMENT_ID = 50;
SELECT * FROM employees
ORDER BY SALARY DESC
LIMIT 1 -- lam limit chi phu hop de tim gia tri lon nhat, neu tim danh sach NV thì cau truy van có the tra ra sai neu nhieu nguoi cung muc luong;

-- xep hang, danh so thu tu
/*
SELECT ROW_NUMBER() OVER(ORDER BY SALARY DESC) AS STT, FIRST_NAME, LAST_NAME, SALARY
FROM employees -- danh so thu tu;

SELECT Rank() OVER(ORDER BY SALARY DESC) AS STT, FIRST_NAME, LAST_NAME, SALARY
FROM employees -- xep hang, 2 nguoi hang 2 thi nguoi tiep theo hang 4;

SELECT dense_Rank() OVER(ORDER BY SALARY DESC) AS STT, FIRST_NAME, LAST_NAME, SALARY
FROM employees -- xep hang, 2 nguoi hang 2 thi nguoi tiep theo la hang 3;

SELECT ROW_NUMBER() OVER(PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) AS STT, FIRST_NAME, LAST_NAME, SALARY
FROM employees -- danh so thu tu theo nhom Department_ID;
*/
SELECT dense_rank() OVER(PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) AS HANG, FIRST_NAME, LAST_NAME, SALARY
FROM employees -- danh so thu tu
WHERE DEPARTMENT_ID is not null;

-- cho biet cac nhan vien co luong lon nhat trong moi phong
select *
from 
	(select 
		department_id,
		employee_id,
		first_name,
		last_name,
		salary,
		DENSE_RANK() OVER(PARTITION BY department_id ORDER BY SALARY DESC) AS ranking
	from employees
	where department_id is not null) t
where t.ranking = 1
order by DEPARTMENT_ID;

-- correlative sub query (truy van con ket hop)
-- liet ke cac phong, tong luong theo phong
/*
SELECT DEPARTMENT_ID, department_name
, IFnull((SELECT sum(SALARY) from employees WHERE DEPARTMENT_ID = d.DEPARTMENT_ID),0) as sum_sal
FROM departments d;

SELECT EMPLOYEE_ID, first_name, salary, manager_id,
	(SELECT FIRSt_NAME FROM employees WHERE EMPLOYEE_ID=E.MANAGER_ID) AS mgr_name
FROM employees E;
*/
SELECT EMPLOYEE_ID, first_name, salary, manager_id,
	(SELECT FIRSt_NAME FROM employees WHERE EMPLOYEE_ID=employees.MANAGER_ID) AS mgr_name
FROM employees -- neu khong dat alias thi mà dung thang ten bang thi trong truong hop nay cau lenh se tham chieu bang gan nhat => lay bảng employees trong cau truy van con => ket qua bị sai, vì mình can lay bang employees trong cau truy van ben ngoai;

-- cho biet cac nhan vien, ten phong
SELECT EMPLOYEE_ID, FIRST_NAME, SALARY, DEPARTMENT_ID,
	(SELECT DEPARTMENT_name FROM departments d WHERE d.DEPARTMENT_ID = e.DEPARTMENT_ID) as Ten_phong
FROM employees e;

-- cho biet cac nhan vien lam truong phong 
SELECT *
FROM employees
WHERE EMPLOYEE_ID in (SELECT MANAGER_ID FROM departments);

-- cho biet cac nhan vien khong lam truong phong 
SELECT *
FROM employees
WHERE EMPLOYEE_ID not in (SELECT DISTINCT MANAGER_ID FROM departments WHERE MANAGER_ID IS NOT null);

-- cach 1
/*
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.SALARY, e.DEPARTMENT_ID, d.DEPARTMENT_NAME
FROM employees e, departments d
WHERE e.DEPARTMENT_ID=d.DEPARTMENT_ID # inner join
*/
-- cach 2: chuan cu phap hon, Where sau nay chi dung de loc dieu kien
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.SALARY, e.DEPARTMENT_ID, d.DEPARTMENT_NAME
FROM employees e INNER JOIN departments d ON e.DEPARTMENT_ID=d.DEPARTMENT_ID;

-- liet ke cac nhan ven lam viec tai cac phong co vi tri 1700
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.SALARY, e.DEPARTMENT_ID, d.DEPARTMENT_NAME, d.LOCATION_ID
FROM employees e INNER JOIN departments d ON e.DEPARTMENT_ID=d.DEPARTMENT_ID
WHERE d.LOCATION_ID = 1700;

-- bang tu ket, liet ke cac nhan vien co ten nguoi quan ly
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.SALARY, e.MANAGER_ID, m.FIRST_NAME
FROM employees e JOIN employees m ON e.MANAGER_ID = m.EMPLOYEE_ID;

-- SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.SALARY, e.DEPARTMENT_ID, d.DEPARTMENT_NAME
-- FROM employees e INNER JOIN departments d ON e.DEPARTMENT_ID=d.DEPARTMENT_ID; -- 106 nhan vien/107 nhan vien
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.SALARY, e.DEPARTMENT_ID, d.DEPARTMENT_NAME
FROM employees e LEFT OUTER JOIN departments d ON e.DEPARTMENT_ID=d.DEPARTMENT_ID; -- ưu tên bảng bên trái (employees) sau do ket hop voi bang ben phai;

-- ket hop cheo CROSS JOIN
SELECT 107*27;
SELECT E.FIRST_NAME, D.DEPARTMENT_NAME
FROM employees E CROSS JOIN departments D -- 2889;

-- liet ke sodh, ngaydh, ma kh, ten kh, masp, tensp, thanh tien
-- orders, customers, orderitems, products
SELECT i.OrderId, i.ProductId, i.UnitPrice*i.Quantity as Total, o.OrderNumber, o.OrderDate, o.CustomerId, c.FirstName, c.LastName, p.ProductName
FROM orderitems i JOIN orders o ON i.OrderId=o.Id JOIN customers c on o.CustomerId = c.Id JOIN products p ON i.ProductId=p.Id
ORDER BY i.OrderId ;










