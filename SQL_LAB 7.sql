SELECT YEAR(GETDATE()) - YEAR(NGSINH) as N'Tu?i'
FROM NHANVIEN 
WHERE MANV = '001'

if OBJECT_ID('fTuoiNV') is not null
	drop function fn_tuoiNV
go

CREATE FUNCTION fTuoiNV(@MaNV nvarchar(9))
RETURNS INT
AS 
BEGIN
	RETURN(SELECT YEAR(GETDATE()) - YEAR(NGSINH) AS N'TU?I'
		FROM NHANVIEN WHERE MANV = @MaNV)
END

print 'Tuoi nhan vien: ' + convert(nvarchar, dbo.fn_TuoiNV('001'))
----bai 1 b
SELECT MA_NVIEN, COUNT(MADA) FROM PHANCONG
GROUP BY MA_NVIEN

SELECT COUNT(MADA) FROM PHANCONG WHERE MA_NVIEN = '004'

IF OBJECT_ID('fDemDeAnNV') is not null
	drop function fn_DemDeAnNV
go
CREATE FUNCTION fDemDeAnNV(@MaNV varchar(9))
returns int
as
	begin
		return(select count(MADA) from PHANCONG where MA_NVIEN = @MaNV)
	end

print ' so du an nhan vien da lam la: ' + convert(varchar, dbo.fn_DemDeAnNV('004'))

----bai 1 c

SELECT * FROM NHANVIEN
SELECT COUNT(*) FROM NHANVIEN WHERE PHAI LIKE 'Nam'
SELECT COUNT(*) FROM NHANVIEN WHERE PHAI LIKE N'N?'

create function fn_demnv_phai(@Phai nvarchar(5) = N'%')
returns int
as 
	begin
		return(select count(*) 
		from NHANVIEN
		where PHAI like @Phai)
	end

print 'nhan vien nam: ' + convert(varchar, dbo.fn_demnv_phai('Nam'))
print 'nhan vien nu: ' + convert(varchar, dbo.fn_demnv_phai(N'N?'))
--bai 1 d
if OBJECT_ID('fLuong_NhanVien_PB')is not null
	drop function fn_Luong_NhanVien_PB 
go
create function fLuong_NhanVien_PB(@TenPhongBan nvarchar(20))
returns @tbLuongNV table(fullname nvarchar (50), luong float)
as 
	begin
		declare @LuongTB float
		select @LuongTB = AVG(LUONG) from NHANVIEN
		inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
		where TENPHG = @TenPhongBan
		--print 'Luong Trung Binh: '+ convert(nvarchar.@LuongTB)
		--insert vao table
		insert into @tbLuongNV
			select HONV+' '+TENLOT+' '+TENNV, LUONG from NHANVIEN
			where LUONG > @LuongTB
		return
	end

select * from dbo.fLuong_NhanVien_PB('IT')

--bai 1 e
if object_id('fn_soLuongDeAnTheoPB') is not null
	drop function fn_soLuongDeAnTheoPB
	go
CREATE FUNCTION fsoLuongDeAnTheoPB(@MaPB int)
returns @tbListPB table(TenPB nvarchar(20), MATP nvarchar(10), TenTP nvarchar(50), soLuong int)
as 
begin
	insert into @tbListPB
	SELECT TENPHG, TRPHG, HONV + ' ' + TENLOT + ' ' + TENNV as 'Ten truong phong', 
	COUNT(MADA) as 'SOLUONGDEAN' FROM PHONGBAN
		INNER JOIN DEAN ON DEAN.PHONG = PHONGBAN.MAPHG
		INNER JOIN NHANVIEN ON NHANVIEN.MANV = PHONGBAN.TRPHG
		WHERE PHONGBAN.MAPHG = @MaPB
		GROUP BY TENPHG, TRPHG, TENNV, HONV, TENLOT
	return
end

select * from dbo.fsoLuongDeAnTheoPB(1)
--bai 2 a
select HONV,TENPHG,DIADIEM from PHONGBAN
inner join DIADIEM_PHG on DIADIEM_PHG.MAPHG = PHONGBAN.MAPHG
inner join NHANVIEN on NHANVIEN.PHG = PHONGBAN.MAPHG

create view v_DD_PhongBan
as
select HONV,TENPHG,DIADIEM from PHONGBAN
inner join DIADIEM_PHG on DIADIEM_PHG.MAPHG = PHONGBAN.MAPHG
inner join NHANVIEN on NHANVIEN.PHG = PHONGBAN.MAPHG

select * from v_DD_PhongBan

--bai 2 b
select TENNV,LUONG,YEAR(GETDATE())-YEAR(NGSINH)as 'Tuoi' from NHANVIEN

create view v_TuoiNV
as
select TENNV,LUONG,YEAR(GETDATE())-YEAR(NGSINH)as 'Tuoi' from NHANVIEN

select * from v_TuoiNV

--bai 2 c
select top(1) TENPHG,TRPHG,B.HONV+' '+B.TENLOT+' '+B.TENNV as 'TenTP',COUNT(A.MANV)as 'SoLuongNV' from NHANVIEN A
inner join PHONGBAN on PHONGBAN.MAPHG = A.PHG
inner join NHANVIEN B on B.MANV = PHONGBAN.TRPHG
group by TENPHG,TRPHG,B.TENNV,B.HONV,B.TENLOT
order by SoLuongNV desc

create view v_TopSoLuongNV_PB
as
select top(1) TENPHG,TRPHG,B.HONV+' '+B.TENLOT+' '+B.TENNV as 'TenTP',COUNT(A.MANV)as 'SoLuongNV' 
from NHANVIEN A
inner join PHONGBAN on PHONGBAN.MAPHG = A.PHG
inner join NHANVIEN B on B.MANV = PHONGBAN.TRPHG
group by TENPHG,TRPHG,B.TENNV,B.HONV,B.TENLOT
order by SoLuongNV desc

select * from v_TopSoLuongNV_PB