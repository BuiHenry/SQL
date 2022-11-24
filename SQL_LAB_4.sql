declare @tbthongke table(mapb int, luongtb float)
insert into @tbthongke
select phg, avg(luong) from NHANVIEN group by PHG
select tennv,luong,luongtb,tinhtrang=case
when luong > luongtb then 'khong tang luong'
else 'tang luong'
end
  from NHANVIEN a
inner join @tbthongke b
on a.phg=b.mapb

------------------------------------

declare @tbthongke table(mapb int, luongtb float)
insert into @tbthongke
select phg, avg(luong) from NHANVIEN group by PHG
select tennv,luong,luongtb,tinhtrang=case
when luong > luongtb then 'truong phong'
else 'nhan vien'
end
  from NHANVIEN a
inner join @tbthongke b
on a.phg=b.mapb

----------------

select * from NHANVIEN
select IIF(phai=N'nam','Mr. ','Ms. ')+TENNV as 'ten' from NHANVIEN

---------------

select tennv, luong,
thue=case
when luong between 0 and 25000 then LUONG*0.1
when luong between 25000 and 30000 then LUONG*0.12
when luong between 30000 and 40000 then LUONG*0.15
when luong between 40000 and 50000 then LUONG*0.2
else luong * 0.25
end
from NHANVIEN

-----------------

select *from NHANVIEN
declare @i int=2, @dem int;
set @dem = (select count(*) from NHANVIEN )
while (@i < @dem)
begin
select manv,honv,tenlot,tennv from NHANVIEN
where cast	(manv as int)=@i;
set @i=@i+2;
end

-----------------

select * from NHANVIEN
declare @i int=2, @dem int;
set @dem = (select count(*) from NHANVIEN )
while (@i < @dem)
begin
if(@i=4)
begin 
set @i =@i+2;
continue;
end
select manv,honv,tenlot,tennv from NHANVIEN
where cast	(manv as int)=@i;
set @i=@i+2;
end

-----------------