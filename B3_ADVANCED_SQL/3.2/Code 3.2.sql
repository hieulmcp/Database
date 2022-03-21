-- 1a. Liệt kê danh sách sinh viên gồm các cột Mã, Họ và Tên, Ngày sinh, Giới tính, Học bổng. Có sắp tăng theo cột học bổng
select "Ma_sinh_vien"
, concat(concat ("Ho" ,' '),"Ten") as "Ho_ten"
,"Ngay_sinh"
,case when "Gioi_tinh" = 'True' then 'Nam' else 'Nu' end as "Gioi_tinh"
, "Hoc_bong"
from sinh_vien 
order by "Hoc_bong"

-- 1b. Hiển thị danh sách 10 sinh viên đầu tiên có học bổng từ cao đến thấp (Hướng dẫn: dùng FETCH FIRST 10 ROWS ONLY và ORDER BY … DESC)
select "Ma_sinh_vien"
, "Ho"
,"Ten"
, "Hoc_bong"
, "Ma_khoa"
from sinh_vien 
order by "Hoc_bong" desc
 FETCH FIRST 10 ROWS ONLY;

-- 2a. Liệt kê danh sách sinh viên gồm các cột mã, họ, tên, ngày sinh, giới tính, mã khoa, tên khoa
select  "Ma_sinh_vien"
, "Ho"
, s."Ten"
,"Ngay_sinh"
,"Gioi_tinh"
, s."Ma_khoa"
, k."Ten"
from sinh_vien s
left join khoa k on s."Ma_khoa" = k."Ma_khoa";

-- 2b. Liệt kê kết quả học tập gồm các cột mã sinh viên, họ và tên, mã môn học, điểm
select  k."Ma_sinh_vien"
, concat(concat(s."Ho",' '),s."Ten") as "Ho_ten"
, k."Ma_mon"
, k."Diem"
from ket_qua k
left join  sinh_vien s on s."Ma_sinh_vien" = k."Ma_sinh_vien";

-- 2c. Liệt kê danh sách các sinh viên (gồm các cột mã, họ tên, ngày sinh) có học môn ‘Cơ sở dữ liệu’
select  distinct k."Ma_sinh_vien"
, concat(concat(s."Ho",' '),s."Ten") as "Ho_ten"
, s."Ngay_sinh"
from ket_qua k
left join  sinh_vien s on s."Ma_sinh_vien" = k."Ma_sinh_vien"
left join mon_hoc m on m."Ma_mon" = k."Ma_mon"
where m."Ten" like 'Cơ sở dữ liệu%'

-- 2d. Liệt kê danh sách các sinh viên (gồm các cột mã, họ tên, ngày sinh) đạt điểm 10 trong bài thi
select  distinct k."Ma_sinh_vien"
, concat(concat(s."Ho",' '),s."Ten") as "Ho_ten"
, s."Ngay_sinh"
, k."Diem"
from ket_qua k
left join  sinh_vien s on s."Ma_sinh_vien" = k."Ma_sinh_vien"
where k."Diem" = 10;


-- 2e. Liệt kê danh sách các sinh viên (gồm các cột mã, họ tên, ngày sinh) có điểm thi môn ‘Toán cao cấp’ lớn hơn 5
select  distinct k."Ma_sinh_vien"
, concat(concat(s."Ho",' '),s."Ten") as "Ho_ten"
, s."Ngay_sinh"
, m."Ten"
, k."Diem"
from ket_qua k
left join  sinh_vien s on s."Ma_sinh_vien" = k."Ma_sinh_vien"
left join mon_hoc m on m."Ma_mon" = k."Ma_mon"
where k."Diem" = 10 and m."Ten" like 'Toán cao cấp%';

-- 2f. Cho biết danh sách các môn học chưa có sinh viên đăng ký
select m."Ma_mon", m."Ten"
from mon_hoc m
where m."Ma_mon" not in
(select  distinct k."Ma_mon" from ket_qua k where k."Ma_mon" is not null);


-- 2g. Cho biết danh sách các sinh viên (gồm các cột mã, họ tên, ngày sinh) chưa đăng ký học môn học nào 
select s."Ma_sinh_vien"
, concat(concat(s."Ho",' '),s."Ten") as "Ho_ten"
, s."Ngay_sinh"
from sinh_vien s
where s."Ma_sinh_vien" not in
(select  distinct k."Ma_sinh_vien" from ket_qua k where k."Ma_sinh_vien" is not null);

-- 3a. Thống kê tổng số sinh viên theo khoa. Có sắp tăng theo tổng số sinh viên.
select "Ma_khoa", count(*) as "So_sinh_vien"
from sinh_vien
group by "Ma_khoa";

-- 3b. Thống kê tổng học bổng theo khoa. Chỉ hiển thị những khoa có tổng học bổng >=150,000,000
select s."Ma_khoa", k."Ten", sum(s."Hoc_bong") as "Tong_hoc_bong"
from sinh_vien s join khoa k on s."Ma_khoa"=k."Ma_khoa"
group by s."Ma_khoa", k."Ten"
having sum(s."Hoc_bong") >= 150000000;


-- 3c. Hiển thị danh sách sinh viên gồm mã, họ tên và điểm trung bình các môn học mà sinh viên có đăng ký học
select k."Ma_sinh_vien", concat(concat(s."Ho",' '),s."Ten") as "Ho_ten", avg(k."Diem") as "Diem_trung_binh"
from ket_qua k join sinh_vien s on s."Ma_sinh_vien"=k."Ma_sinh_vien"
group by k."Ma_sinh_vien", concat(concat(s."Ho",' '),s."Ten");

-- 3c. Hiển thị danh sách sinh viên gồm mã, họ tên và điểm trung bình các môn học mà sinh viên có đăng ký học
select k2."Ma_khoa"
, k2."Ten"
, avg(k."Diem") as "Diem_trung_binh"
from ket_qua k 
join sinh_vien s on s."Ma_sinh_vien"=k."Ma_sinh_vien"
join khoa k2 on k2."Ma_khoa"=s."Ma_khoa"
group by k2."Ma_khoa" , k2."Ten";


-- 3e. Hiển thị danh sách sinh viên gồm mã, họ tên, điểm trung bình và kết quả xếp loại học tập của sinh viên, 
-- trong đó kết quả xếp loại học tập được xét dựa trên 
-- điểm trung bình theo quy tắc sau: 
-- Điểm trung bình < 5 Yếu
-- 5 <= Điểm trung bình < 6.5 Trung bình
-- 6.5 <= Điểm trung bình < 8 Khá
-- Điểm trung bình >= 8 Giỏi
select k."Ma_sinh_vien"
, concat(concat(s."Ho",' '),s."Ten") as "Ho_ten"
, avg(k."Diem") as "Diem_trung_binh"
, case 
	when avg(k."Diem") < 5 then 'Yeu'
	when avg(k."Diem") < 6.5 then 'Trung binh'
	when avg(k."Diem") < 8 then 'Kha'
	else 'Gioi'
	end as "Xep_loai"
from ket_qua k
left join sinh_vien s on s."Ma_sinh_vien" = k."Ma_sinh_vien"
group by k."Ma_sinh_vien"
, concat(concat(s."Ho",' '),s."Ten");

-- 3f. Hiển thị danh sách các môn học cùng với điểm thi cao nhất mà sinh viên đã đạt được trong môn học đó, 
-- kết quả trả về gồm mã môn, tên môn, điểm thi cao nhất của sinh viên 
select k."Ma_mon"
,m."Ten"
, max(k."Diem") as "Diem_cao_nhat"
from ket_qua k
left join mon_hoc m on m."Ma_mon"=k."Ma_mon"
group by k."Ma_mon", m."Ten";

-- 3g. Hiển thị danh sách các môn học cùng với số lượng sinh viên đã đăng ký học các môn học đó, 
-- kết quả trả về gồm mã môn, tên môn, số lượng sinh viên đã đăng ký
select k."Ma_mon"
, m."Ten"
, count(*) as "So_sinh_vien"
from ket_qua k join mon_hoc m on m."Ma_mon"=k."Ma_mon"
group by  k."Ma_mon", m."Ten";


-- 3h. Hiển thị danh sách các môn học có số lượng sinh viên đăng ký học đông nhất, kết quả trả về gồm mã môn, tên môn và số lượng sinh viên đăng ký 
select t."Ma_mon", m."Ten", t."So_sinh_vien"
from(
select k."Ma_mon", count(*) as "So_sinh_vien", rank() over(order by count(*) desc) as "Thu_tu"
from ket_qua_2 k
group by  k."Ma_mon"
) t
left join mon_hoc m on m."Ma_mon" = t."Ma_mon"
where t."Thu_tu" = 1;

-- 3i. Thống kê số lượng sinh viên đậu và rớt của từng môn, biết rằng sinh viên rớt khi điểm thi nhỏ hơn 5, 
-- kết quả trả về gồm mã môn, tên môn, số sinh viên đậu, số sinh viên rớt
select k."Ma_mon", m."Ten"
, sum(case when k."Diem" < 5 then 1 else 0 end) as "Rot" 
, sum(case when k."Diem" >= 5 then 1 else 0 end) as "Dau" 
from ket_qua_2 k left join mon_hoc m on m."Ma_mon"=k."Ma_mon"
group by k."Ma_mon", m."Ten";


