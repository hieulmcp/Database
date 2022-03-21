-- 4a. Hien thi danh sach nhan vien theo mau
SELECT `empid`as `Ma nhan vien`
, concat(`firstname`," ",`lastname`) as `Ho va ten`
,`title` as `Chuc danh`
,date_format(`hiredate`,"%d/%m/%Y") as `Ngay vao lam`
FROM employees;

-- 4b. Hien thi cac chuc danh
SELECT DISTINCT title as `Chuc danh`
FROM employees;

-- 4c. Hien thi Ma san pham voi do rong 10 ky tu
SELECT `productid` as `Ma hang hoa`
, lpad(`productid`,10,0) as `Ma hang hoa moi`
FROM products;

-- 5a.  Hien thi don dat hang 6 thang dau nam 2008, sap xep theo ngay dat hang giam dan
SELECT * 
FROM `orders` 
WHERE year(`orderdate`) = 2008 and month(`orderdate`) BETWEEN 1 and 6
ORDER BY orderdate DESC;

-- 5b.  Hiển thị các đơn đặt hàng đã chuyển đến Germany trong tháng 06 năm 2007
SELECT * 
FROM `orders` 
WHERE year(`orderdate`) = 2007 and month(`orderdate`) = 6
and `shipcountry` = "Germany"
ORDER BY orderdate DESC 