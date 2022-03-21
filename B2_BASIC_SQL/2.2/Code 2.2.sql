-- 4a. Liệt kê danh sách sinh viên gồm các cột Mã, Họ và Tên, Ngày sinh, Giới tính, Học bổng.
SELECT `Ma_sinh_vien` as `Ma sinh vien`
,concat(`Ho`," ",`Ten`) as `Ho va ten`
,`Ngay_sinh` as `Ngay sinh`
,`Gioi_tinh` as `Gioi tinh`
,`Hoc_bong` as `Hoc bong`
FROM sinh_vien;

-- 4b. Liệt kê danh sách sinh viên gồm các cột Mã, Họ, Tên, Ngày sinh, Giới tính, Học bổng. 
-- Chỉ liệt kê các sinh viên học khoa “Công nghệ thông tin” và có học bổng >1,000,000
SELECT `Ma_sinh_vien` as `Ma sinh vien`
,`Ho`
,`Ten`
,`Ngay_sinh` as `Ngay sinh`
,`Gioi_tinh` as `Gioi tinh`
,`Hoc_bong` as `Hoc bong`
, Ma_khoa
FROM sinh_vien
WHERE Ma_khoa = "CN"
and Hoc_bong >1000000;

-- 4c. Liệt kê danh sách sinh viên gồm các cột Mã, Họ, Tên, Ngày sinh, Giới tính, Học bổng. 
-- Chỉ liệt kê các sinh viên có học bổng từ 1000000 đến 2000000
SELECT `Ma_sinh_vien` as `Ma sinh vien`
,`Ho`
,`Ten`
,`Ngay_sinh` as `Ngay sinh`
,`Gioi_tinh` as `Gioi tinh`
,`Hoc_bong` as `Hoc bong`
FROM sinh_vien
WHERE Hoc_bong BETWEEN 1000000 AND 2000000;

-- 4d. Liệt kê danh sách sinh viên gồm các cột Mã, Họ, Tên, Ngày sinh, Học bổng. Chỉ liệt 
-- kê các sinh viên có học bổng và ngày sinh nằm trong khoảng [1/6/1998, 30/6/1999]
SELECT `Ma_sinh_vien` as `Ma sinh vien`
,`Ho`
,`Ten`
,`Ngay_sinh` as `Ngay sinh`
,`Gioi_tinh` as `Gioi tinh`
,`Hoc_bong` as `Hoc bong`
FROM sinh_vien
WHERE Hoc_bong > 0
and Ngay_sinh BETWEEN "01-06-1998" and "30-06-1999";

-- 4e. Hiển thị danh sách 10 sinh viên đầu tiên có học bổng.
SELECT *
FROM sinh_vien
WHERE Hoc_bong > 0
LIMIT 10;

-- 5a. Cập nhật ngày sinh của sinh viên ‘Hoàng Nam Tuấn’ thành 05/07/1999
UPDATE sinh_vien
SET Ngay_sinh = "05-07-1999 00:00:00"
WHERE concat(Ho," ",Ten) = "Hoàng Nam Tuấn";

-- 5b. Tăng học bổng lên 5% cho các sinh viên học khoa ‘Công nghệ thông tin’ và có học bổng >0
UPDATE sinh_vien
SET Hoc_bong = round((Hoc_bong * (1+5/100)),0)
WHERE Hoc_bong > 0 and Ma_khoa = "CN";

-- 5c. Cập nhật học bổng là 500,000 cho các sinh viên nữ học khoa ‘Công nghệ thông tin’ và chưa có học bổng
UPDATE sinh_vien
SET Hoc_bong = 500000
WHERE Hoc_bong = 0 and Gioi_tinh = False;

-- 5d. Cộng thêm 0.5 điểm môn ‘Trí Tuệ Nhân Tạo’ cho các sinh viên thuộc khoa ‘Công 
-- nghệ thông tin’. Lưu ý: Điểm tối đa của môn là 10
UPDATE ket_qua a
LEFT JOIN sinh_vien b on a.Ma_sinh_vien = b.Ma_sinh_vien
LEFT JOIN mon_hoc c on a.Ma_mon = c.Ma_mon
SET a.Diem = 
	case 
		WHEN( a.Diem + 0.5) >= 10 then 10.0
    	ELSE (a.Diem + 0.5)
  	END
WHERE b.Ma_khoa = "CN"
and c.Ten = "Trí Tuệ Nhân Tạo";

-- 5e. Xoá các kết quả học tập của sinh viên có mã ‘C0001’
DELETE
FROM ket_qua
WHERE Ma_sinh_vien = "C0001";

-- 5f. Xoá sinh viên có mã ‘C0001
DELETE 
FROM sinh_vien
WHERE `Ma_sinh_vien`= "C0001";

-- 5g. Xóa tất cả nam sinh viên của khoa Công nghệ thông tin
DELETE
FROM sinh_vien
WHERE Gioi_tinh = "True" and Ma_khoa = "CN";

-- 5h. Xóa các kết quả học tập của những sinh viên nào có điểm các môn <5
DELETE
FROM ket_qua
WHERE Diem < 5