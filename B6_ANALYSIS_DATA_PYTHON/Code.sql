-- constraints NOT NUL
CREATE TABLE pets (id int, name varchar(30) not null);

INSERT INTO pets VALUES (1,'cat'); -- cho insert

INSERT INTO pets VALUES (2,null); -- ko cho insert

INSERT INTO pets(id) VALUES (2); -- cho insert, name la empty

SELECT * FROM `pets` WHERE name = '';

-- constraints DEFAULT
CREATE TABLE pets 
(id int, name varchar(30) not null, age int DEFAULT 1)
ENGINE = INNODB;

INSERT INTO pets (id, name) VALUES (1,'cat'); 

-- constraints PRIMARY KEY (khai bao constraints o level column)
CREATE TABLE pets 
(id int PRIMARY KEY, 
 name varchar(30) not null, 
 age int DEFAULT 1)
ENGINE = INNODB;

INSERT INTO pets VALUES (1,'cat',2);

INSERT INTO pets VALUES (1,'lion',2); -- ko cho insert do duplicate

INSERT INTO pets VALUES (2,'lion',2);

-- khai bao constraints o level table
CREATE TABLE pets 
(id int, 
name varchar(30) not null, 
age int DEFAULT 1,
PRIMARY KEY(id)
)
ENGINE = INNODB;

-- tao bang dat_hang gom id, ngaydat, ngaygiaodukien
-- id kieu int, primary key
-- ngaydat kieu date, not null, gia tri mac dinh la ngay hien tai
-- ngaygiaodukien kieu date, not null, >= ngaydat

-- ko dat ten constraint
create table dat_hang
(id int PRIMARY KEY,
 ngaydat date not null default (CURRENT_DATE),
 ngaygiaodukien date not null ,
 CONSTRAINT CHECK(ngaygiaodukien >= ngaydat)
) ENGINE = INNODB;

-- co dat ten constraint
create table dat_hang
(id int PRIMARY KEY,
 ngaydat date not null default (CURRENT_DATE),
 ngaygiaodukien date not null ,
 CONSTRAINT ck_dh_ngaygiaodukien CHECK(ngaygiaodukien >= ngaydat)
) ENGINE = INNODB;

INSERT INTO dat_hang(id, ngaygiaodukien) VALUES (1,'2021-06-20');
INSERT INTO dat_hang(id, ngaygiaodukien) VALUES (2,'2021-06-18'); -- vi pham constraint

-- ko co constraint CHECK
create table dat_hang
(id int PRIMARY KEY,
 ngaydat date not null default (CURRENT_DATE),
 ngaygiaodukien date not null
) ENGINE = INNODB;

-- add constraint
alter table dat_hang
add CONSTRAINT ck_dh_ngaygiaodukien CHECK(ngaygiaodukien >= ngaydat);

-- constraint FOREIGN KEY
create table khach_hang
(
id int PRIMARY key,
    tenkh varchar(50)
) ENGINE = INNODB;

create table dat_hang
(
 id int PRIMARY KEY,
 ngaydat date not null default (CURRENT_DATE),
 idkh int 
) ENGINE = INNODB;

alter table dat_hang
add CONSTRAINT fk_dh_idkh 
FOREIGN KEY (idkh) REFERENCES khach_hang(id);

INSERT INTO khach_hang VALUES (1,'An Tu');
INSERT INTO khach_hang VALUES (2,'Tuan Kiet');
INSERT INTO dat_hang (id, idkh) VALUES (1,1);
INSERT INTO dat_hang (id, idkh) VALUES (2,3); -- vi pham constraint