--CÂU 1
select*from PHANCONG
select MA_NVIEN,MADA,STT, 
   cast(THOIGIAN as decimal(5,1)) as 'THOI GIAN' from PHANCONG;

select MA_NVIEN,MADA,STT, 
   convert(decimal(5,1),THOIGIAN) as 'THOI GIAN' from PHANCONG;

--------------------

select*from PHANCONG
select*from DEAN;

declare @ThongKe table (MADA int, thoigian float);
insert into @ThongKe
select MADA, sum(thoigian) as 'Tong thoi gian'  
   from PHANCONG
   group by MADA;
select TENDEAN, cast(thoigian as decimal(5,2)) as 'Tong thoi gian' 
   from @ThongKe a inner join DEAN b on a.MADA = b.MADA
   
select TENDEAN, convert(decimal(5,2),thoigian) as 'Tong thoi gian' 
   from @ThongKe a inner join DEAN b on a.MADA = b.MADA

select TENDEAN, cast(thoigian as varchar(15)) as 'Tong thoi gian' 
   from @ThongKe a inner join DEAN b on a.MADA = b.MADA
   
select TENDEAN, convert(varchar(15),thoigian) as 'Tong thoi gian' 
   from @ThongKe a inner join DEAN b on a.MADA = b.MADA

--------------------

select*from NHANVIEN;
select*from PHONGBAN;
select PHG, convert(decimal(15,2), AVG(luong),1) 
    from NHANVIEN 
	group by PHG;

select PHG, format(convert (decimal(15,2), AVG(luong),1) ,'N', 'vi-VN') 
    from NHANVIEN 
	group by PHG;

select PHG, convert(varchar(50), cast(AVG(luong)as money),1) 
    from NHANVIEN 
	group by PHG;

--CÂU 2
select*from PHANCONG;
select MADA, 
    sum(thoigian) as 'Tổng số giờ làm việc', 
    ceiling(sum(thoigian)) as 'Tổng số giờ làm việc ',
	floor(sum(thoigian)) as 'Tổng số giờ làm việc ',
	round(sum(thoigian),2) as 'Tổng số giờ làm việc '
    from PHANCONG group by MADA;

--------------------

select HONV, TENLOT, TENNV, round(luong,2) as 'Lương' from NHANVIEN where luong>(
    select round(AVG(luong),2) from NHANVIEN 
        where PHG in(select MAPHG from PHONGBAN where TENPHG = N'Nghiên cứu'));

--CÂU 3
select*from nhanvien;
select 
    UPPER( HONV), 
	LOWER( TENLOT), tennv,
	lower(left( TENNV,1)) + upper(SUBSTRING(TENNV, 2, 1)) + lower(SUBSTRING(TENNV, 3, LEN(tennv))),
	dchi,
	CHARINDEX(' ',DCHI),
	CHARINDEX(',',dchi),
	SUBSTRING(dchi, CHARINDEX(' ',DCHI)+1, CHARINDEX(',',dchi) - CHARINDEX(' ',DCHI)-1)
	from NHANVIEN

--------------------

select*from NHANVIEN;
declare @ThongKe table (MaP int, MaNVTP int, TK int);
insert into @ThongKe
select phg,ma_nql, count(manv) from NHANVIEN group by PHG,MA_NQL;

declare @max int;
select @max = max(tk) from @ThongKe;

select TENPHG, HONV + ' ' + TENLOT + ' ' + TENNV, HONV + ' ' + TENLOT + 'Fpoly'
    from PHONGBAN a inner join (
    select*from @ThongKe where tk = @max) b on a.MAPHG = b.MaP
	inner join NHANVIEN c on c.MANV = b.MaNVTP;

--CÂU 4
select*from NHANVIEN;

select*from NHANVIEN where DATENAME(year, NGSINH)>=1960 and DATENAME(year,NGSINH)<=1965

select a.*, DATEDIFF(year, ngsinh, getdate()) +1 as Age from NHANVIEN a;

select a.*, DATENAME(WEEKDAY, ngsinh) from NHANVIEN a;

--------------------

select*from PHONGBAN;
select a.TRPHG,
        c.HONV + ' ' + c.TENLOT + ' ' + c.TENNV 
		convert(varchar, a.NG_NHANCHUC, 105), b.sl - 1
		from PHONGBAN a inner join
        (select PHG, COUNT(manv) as sl from NHANVIEN group by PHG) b on a.MAPHG = b.PHG
		inner join NHANVIEN c on a.TRPHG = c.MANV;