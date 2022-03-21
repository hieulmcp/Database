-- Dung database cua Trung tam tin hoc
-- http://phpmyadmin.laptrinhphp.net/
-- user: hv
-- pass: 123456

-- 1a. Hiển thị các đơn đặt hàng trong 6 tháng đầu năm 2008. Kết quả sắp xếp giảm dần theo ngày đặt hàng.
SELECT * 
FROM orders
WHERE orderdate BETWEEN "2008-01-01 00:00:00" and "2008-06-30 23:59:59"
ORDER BY orderdate DESC;

-- 1b. Hiển thị các đơn đặt hàng đã chuyển đến Germany trong tháng 06 năm 2007
SELECT *
FROM orders
WHERE shipcountry = "Germany"
AND YEAR(shippeddate) = 2007
and MONTH(shippeddate) = 6;

-- 1c. Hiển thị danh sách khách hàng ở những thành phố (city) bắt đầu bằng ký tự 'S', 'O' hoặc 'R'. Kết quả xếp tăng dần theo tên liên lạc (contactname)
SELECT *
FROM customers
WHERE LEFT(city,1) in ("S", "O", "R")
ORDER BY contactname;

-- 1d. Hiển thị danh sách khách hàng ở những thành phố (city) không bắt đầu bằng ký tự 'S', 'O' và 'R'. Kết quả xếp tăng dần theo tên liên lạc (contactname)
SELECT *
FROM customers
WHERE LEFT(city,1) not in ("S", "O", "R")
ORDER BY contactname;

-- 1e. Hiển thị danh sách khách hàng ở những thành phố (city) có ký tự thứ 2 là 'Y'
SELECT *
FROM customers
WHERE city LIKE "_Y%";

-- 1f. Hiển thị danh sách khách hàng ở những thành phố (city) có ký tự cuối cùng 'o'. Kết quả sắp xếp theo tên thành phố tăng dần.
SELECT *
FROM customers
WHERE city LIKE "%o"
ORDER BY city;

-- 1g. Hiển thị danh sách khách hàng ở những thành phố (city) có 2 ký tự cuối cùng 'on'. Kết quả sắp xếp tăng dần theo thành phố.
SELECT *
FROM customers
WHERE city LIKE "%on"
ORDER BY city;

-- 1h. Hiển thị danh sách nhân viên và người quản lý của nhân viên này. Kết quả sắp xếp tăng dần theo mã người quản lý. 
SELECT e.empid, e.lastname, m.empid, m.lastname
FROM employees e JOIN employees m ON m.empid = e.mgrid
ORDER BY m.empid;

-- 1i. Hiển thị danh sách nhân viên và người quản lý của nhân viên này. 
-- Hiển thị thêm nhân viên không có người quản lý. Kết quả sắp tăng dần theo mã người quản lý
SELECT e.empid, e.lastname, m.empid, m.lastname
FROM employees e LEFT JOIN employees m ON m.empid = e.mgrid
ORDER BY m.empid;

-- 1j. Hiển thị những mặt hàng chưa có đơn đặt hàng (man hinh chup la "in", nhung cau hoi la "not in"
SELECT *
FROM products
WHERE productid not in (SELECT DISTINCT productid FROM orderdetails WHERE productid is not null);

-- 1k. Hiển thị những nhân viên chưa có đơn đặt hàng nào
SELECT *
FROM employees 
WHERE empid not in (SELECT DISTINCT empid FROM orders WHERE empid is not null);

-- 1l. Hiển thị các đơn đặt hàng của từ Đức hoặc Brazil theo mẫu sau. kết quả sắp xếp theo ngày đặt hàng
SELECT o.custid, o.shipcountry, o.orderid, o.orderdate, o.requireddate, e.lastname
FROM orders o LEFT JOIN employees e on o.empid=e.empid
WHERE shipcountry in ("Germany","Brazil");

-- 2a. Hiển thị thông tin của sản phẩm và phân loại giá bán với điều kiện sau
-- Unitprice < 20 Thấp
-- 20 <= Unitprice < 40 Trung bình
-- >= 40 Cao
SELECT productid, productname, unitprice,
	CASE
    	WHEN unitprice < 20 THEN "Thap"
        WHEN unitprice < 40 THEN "Trung binh"
        ELSE "Cao"
    END as "Gia"
FROM products;

-- 2b. Hiển thị những san pham có giá trị lớn hơn 11000
SELECT productid, SUM(unitprice * qty) as Gia_tri
FROM orderdetails
GROUP BY productid
HAVING Gia_tri > 11000;

-- 2b. Hiển thị những san pham có giá trị lớn hơn 11000
-- Cach 1:
SELECT d.productid, d.productname, MAX(d.dem) as dem
FROM
(SELECT o.productid, p.productname, COUNT(*) as dem 
FROM orderdetails o JOIN products p ON o.productid = p.productid
GROUP BY o.productid
ORDER BY dem DESC) d;
-- Cach 2:
SELECT *
FROM 
(
	SELECT 
		p.productid,
		p.productname,
		rank() over(order by count(o.orderid) desc) as hang,
    	count(*) as dem
	FROM products p 
	JOIN orderdetails o
		on p.productid = o.productid
	GROUP BY
		p.productid,
		p.productname
	) t
WHERE t.hang = 1;


-- 3.a. Hiển thị số lượng các đơn đặt hàng trong các năm 2005, 2006, 2007, 2008 và tổng số đơn đặt hàng theo mẫu sau:
SELECT 
(SELECT count(*) FROM orders WHERE year(orderdate) = 2005) as "Nam 2005",
(SELECT count(*) FROM orders WHERE year(orderdate) = 2006) as "Nam 2006",
(SELECT count(*) FROM orders WHERE year(orderdate) = 2007) as "Nam 2007",
(SELECT count(*) FROM orders WHERE year(orderdate) = 2008) as "Nam 2008",
(SELECT count(*) FROM orders) as "Tong"

-- 3b. Hiển thị số lương đơn đặt hàng do các nhân viên bán được trong các năm 2005, 2006, 2007, 2008 theo mẫu sau
-- Cach 1
SELECT e.empid, ifnull(a.nam2005,0) as "Nam 2005", ifnull(b.nam2006,0) as "Nam 2006", ifnull(c.nam2007,0) as "Nam 2007", ifnull(d.nam2008,0) as "Nam 2008", ifnull(t.tong,0) as Tong
FROM employees e
LEFT JOIN (SELECT empid, count(*) as nam2005 FROM orders WHERE year(orderdate) = 2005 GROUP by empid) a on e.empid = a.empid
LEFT JOIN (SELECT empid, count(*) as nam2006 FROM orders WHERE year(orderdate) = 2006 GROUP by empid) b on e.empid = b.empid
LEFT JOIN (SELECT empid, count(*) as nam2007 FROM orders WHERE year(orderdate) = 2007 GROUP by empid) c on e.empid = c.empid
LEFT JOIN (SELECT empid, count(*) as nam2008 FROM orders WHERE year(orderdate) = 2008 GROUP by empid) d on e.empid = d.empid
LEFT JOIN (SELECT empid, count(*) as tong FROM orders GROUP by empid) t on e.empid = t.empid
ORDER BY e.empid
-- Cach 2
SELECT a2.empid
, ifnull(SUM(a2.N2005),0) as "Nam 2005"
, ifnull(SUM(a2.N2006),0) as "Nam 2006"
, ifnull(SUM(a2.N2007),0) as "Nam 2007"
, ifnull(SUM(a2.N2008),0) as "Nam 2008"
, (ifnull(SUM(a2.N2005),0)+ifnull(SUM(a2.N2006),0)+ifnull(SUM(a2.N2007),0)+ifnull(SUM(a2.N2008),0)) as Tong
FROM
(SELECT a1.empid,
	CASE WHEN Nam = 2005 THEN ifnull(Soluong,0) END AS "N2005",
	CASE WHEN Nam = 2006 THEN ifnull(Soluong,0) END AS "N2006",
    CASE WHEN Nam = 2007 THEN ifnull(Soluong,0) END AS "N2007",
    CASE WHEN Nam = 2008 THEN ifnull(Soluong,0) END AS "N2008"
FROM
(SELECT empid, year(orderdate) as Nam, count(*) as Soluong
FROM orders GROUP BY empid, Nam) a1
) a2
GROUP BY a2.empid

