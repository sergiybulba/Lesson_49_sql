--  1) ���������� �� Dating
--   done

--  2) � ��� ��������� (��� 9 �� 10) ���������� ��� ������������ ��������� ���������� � ������ ������:
--  - ��������� ����� ������� ����������� � ��������� �����
--  - ��
--  - ��
--  - �����
--  + �������� ����, ������ � �����.
--  ok

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--======================================================================================================

-- 1. �������� TOP-10 ������������ � �������� ������� ��������� ������ (Anketa_Rate, AVG, 
--    ������� ������� �� ���� ������������� � ������ ������� �����)

select top 10 users.user_id as User_unique_ID,
	   users.nick as User_nick,
	   users.age as User_age,
	   gender.name as User_sex,
	   round(avg(cast (anketa_rate.rating as float)), 2) as Avg_rating
from users inner join anketa_rate on users.user_id = anketa_rate.id_kogo
		   inner join gender on users.sex = gender.id
group by users.user_id, users.nick, users.age, users.sex, gender.name
order by Avg_rating desc;

--======================================================================================================
-- 2. �������� ��� ������������ � ����� ������, �� �� ������, �� �'��� �� �� �������� ���������

/*select * from users
select * from education
select * from smoking
select * from drinking
select * from drugs*/

select users.user_id as User_unique_ID,
	   users.nick as User_nick,
	   users.age as User_age,
	   gender.name as User_sex
from users inner join gender on users.sex = gender.id
		   inner join education on education.id = users.id_education
		   inner join smoking on smoking.id = users.my_smoke
		   inner join drinking on drinking.id = users.my_drink
		   inner join drugs on drugs.id = users.my_drugs
where education.id >= 4 and smoking.id = 1 and drinking.id = 1 
      and (drugs.id = 1 or drugs.id = 6 or drugs.id = 7);

/*select users.user_id as User_unique_ID,	-- ��� ��������
	   users.nick as User_nick,
	   users.age as User_age,
	   users.sex as User_sex,
	   users.id_education as Education,
	   users.my_smoke as Smoke,
	   users.my_drink as Drink,
	   users.my_drugs as Drug
	   
from users
where users.user_id = 9173965; */

--======================================================================================================
-- 3. ������� �����, ���� ��������� ������ ������������ �� ��������� ������:
--    - �� (�� ����'������ ������)
--    - �����
--    - ��������� �� ������������ ��
--    - �������� �� ����������� ����
--    - �������� �� ����������� ����

declare @nick nvarchar(50) = '%nick%';
declare @min_age int = 15;
declare @max_age int = 30;
declare @min_height int = 175;
declare @max_height int = 195;
declare @min_weight int = 70;
declare @max_weight int = 90;

select users.user_id as User_unique_ID,
	   users.nick as User_nick, users.age as User_age, gender.name as User_sex,
	   users.rost as User_height, users.ves as User_weight
from users inner join gender on users.sex = gender.id
where users.nick like @nick and users.age >= @min_age and users.age <= @max_age
	  and users.rost >= @min_height and users.rost <= @max_height
	  and users.ves >= @min_weight and users.ves <= @max_weight;

--======================================================================================================
-- 4. �������� ��� �������� ������������ ���������, ���� ��� ���������� �������� �������, 
--    � � ���� �� �������� ������� (UNION, ����� ������� �� SELECT)

/*select * from haircolor		-- 1 - �����, 4 - ������
select * from eyescolor		-- 4 - �������, 2 - ��� ���
select * from figure		-- 2 - ������, 4 - ��������*/

select users.user_id as User_unique_ID,
	   users.nick as User_nick,
	   users.age as User_age,
	   gender.name as User_sex,
	   figure.name as User_figure,
	   eyescolor.name as User_eyescolor,
	   haircolor.name as User_haircolor
from users inner join gender on users.sex = gender.id
		   inner join haircolor on haircolor.id = users.hair_color
		   inner join eyescolor on eyescolor.id = users.eyes_color
		   inner join figure on figure.id = users.my_build
where gender.id = 2 and eyescolor.id = 4 and haircolor.id = 1 and figure.id = 2 
union all
select users.user_id, users.nick, users.age, gender.name, figure.name,
	   eyescolor.name, haircolor.name
from users inner join gender on users.sex = gender.id
		   inner join haircolor on haircolor.id = users.hair_color
		   inner join eyescolor on eyescolor.id = users.eyes_color
		   inner join figure on figure.id = users.my_build
where gender.id = 1 and eyescolor.id = 2 and haircolor.id = 4 and figure.id = 4;

--------------------------------------------------------------------------------------------------------
-- �������� ������� ����� � ��������� ������ (�� ����� �� ��'������ � ������ �����?)

select count(*) as Count_people
from  (select users.user_id as User_unique_ID,
			   users.nick as User_nick,
			   users.age as User_age,
			   gender.name as User_sex,
			   figure.name as User_figure,
			   eyescolor.name as User_eyescolor,
			   haircolor.name as User_haircolor
		from users inner join gender on users.sex = gender.id
				   inner join haircolor on haircolor.id = users.hair_color
				   inner join eyescolor on eyescolor.id = users.eyes_color
				   inner join figure on figure.id = users.my_build
		where gender.id = 2 and eyescolor.id = 4 and haircolor.id = 1 and figure.id = 2
		union all
		select users.user_id, users.nick, users.age, gender.name, figure.name,
			   eyescolor.name, haircolor.name
		from users inner join gender on users.sex = gender.id
				   inner join haircolor on haircolor.id = users.hair_color
				   inner join eyescolor on eyescolor.id = users.eyes_color
				   inner join figure on figure.id = users.my_build
		where gender.id = 1 and eyescolor.id = 2 and haircolor.id = 4 and figure.id = 4) as TempTable;

--======================================================================================================
-- 5. �������� ��� ���������� � ��������, �� �� ���� � ����� �������� ��������� (Moles, Framework �� Interes)

/*select * from moles
select * from framework
select * from interes*/

select users.user_id as User_unique_ID,
	   users.nick as User_nick,
	   users.age as User_age,
	   gender.name as User_sex
from users inner join gender on users.sex = gender.id
		   inner join framework on framework.id = users.id_framework
		   inner join users_moles on users.user_id = users_moles.user_id
		   inner join moles on moles.id = users_moles.moles_id
		   inner join users_interes on users.user_id = users_interes.user_id
		   inner join interes on interes.id = users_interes.interes_id

where framework.id = 1 and moles.id = 1 and interes.id = 23;

/*select users.user_id as User_unique_ID,	-- ��� ��������
	   users.nick as User_nick,
	   users.age as User_age,
	   users.sex as User_sex,
	   users.id_framework as Framework,
	   users_moles.moles_id as Moles,
	   users_interes.interes_id as Interes
	   
from users, users_moles, users_interes
where users.user_id = users_moles.user_id and 
	  users.user_id = users_interes.user_id and
	  users.user_id = 38888867; */

--======================================================================================================
-- 6. �������� ������ ��������� ���������� ������� �����������, ���� �� ���� ������ ����

/*select * from goroskop
select * from gift_service*/

select users.user_id as User_unique_ID,
	   users.nick as User_nick,
	   users.age as User_age,
	   gender.name as User_sex,
	   TempTable.Count_presents as Count_presents
from users inner join gender on users.sex = gender.id
		   inner join goroskop on users.id_zodiak = goroskop.id,
		   (select gift_service.id_to as User_ID, count(gift_service.id_to) as Count_presents
		    from gift_service
		    group by gift_service.id_to) as TempTable
where goroskop.id = 12 and users.user_id = TempTable.User_ID;

/*select users.user_id as User_unique_ID,	-- ��� ��������
	   users.nick as User_nick,
	   users.age as User_age,
	   users.sex as User_sex,
	   gift_service.id_to as Gift
	   
from users, gift_service
where users.user_id = gift_service.id_to and gift_service.id_to = 31459214; */

--======================================================================================================
-- 7. �������� �� ������ ���������� ��� �� ����� �������� (�� ������ ����� 5 ���), �� ����� �� ����� ��������

/*select * from languages
select * from kitchen*/

select users.user_id as User_unique_ID,
	   users.nick as User_nick,
	   users.age as User_age,
	   gender.name as User_sex
from users inner join gender on users.sex = gender.id
		   inner join kitchen on users.like_kitchen = kitchen.id,
		   (select users_languages.user_id as User_ID, count(users_languages.user_id) as Count_languages 
		    from users_languages
		    group by users_languages.user_id) as TempTable
where (kitchen.id = 2 or kitchen.id = 5) and 
	   users.user_id = TempTable.User_ID and TempTable.Count_languages > 5;



--======================================================================================================
-- 8. �������� ��� ��������, �� ���������� �������� ��������������, ������ �� ������, 
--    �� � ������ ��� ��������� �� �����

/*select * from religion	-- 6 - �������
select * from residence		-- 9 - ������
select * from sport 		-- 6 - ���������, 9 - ������������
select * from interes*/

select users.user_id as User_unique_ID,		-- ������ ��� ���� ?
	   users.nick as User_nick,
	   users.age as User_age,
	   gender.name as User_sex
from users inner join gender on users.sex = gender.id
		   inner join religion on users.religion = religion.id
		   inner join residence on users.rec_mess = residence.id
		   inner join users_sport on users.user_id = users_sport.user_id
		   inner join sport on sport.id = users_sport.sport_id

where religion.id = 6 and residence.id = 9 and (sport.id = 6 or sport.id = 9);


/*select users.user_id as User_unique_ID,			-- ��������: ������� � ���� �� ������ - �������� ���� ���� ������,
	   users.nick as User_nick,						-- ���� ������ ����� - ����� ����� ����
	   users.age as User_age,
	   gender.name as User_sex
from users inner join gender on users.sex = gender.id
		   inner join residence on users.rec_mess = residence.id
		   inner join religion on users.religion = religion.id

where religion.id = 6 and residence.id = 9; */

--======================================================================================================
-- 9. �������� ����� �������� ������������ � ������:
   /* �� � %:   �� 18 2000 40.0
				 18-24 1500 30.0
				 24-30 1000 20.0
				�� 30  500 10.0 */

declare @total_people1 int = 0;
declare @total_people2 int = 0;
declare @total_people3 int = 0;
declare @total_people4 int = 0;
declare @current_person_age int;

declare	user_cursor cursor for select users.age from users;
open user_cursor;
fetch next from user_cursor into @current_person_age;

while @@fetch_status = 0
begin--{
	if @current_person_age < 18
		begin
			set @total_people1 += 1;
		end
	if @current_person_age >= 18 and @current_person_age < 24
		begin
			set @total_people2 += 1;
		end
	if @current_person_age >= 24 and @current_person_age < 30
		begin
			set @total_people3 += 1;
		end
	if @current_person_age >= 30
		begin
			set @total_people4 += 1;
		end
	fetch next from user_cursor into @current_person_age;
end--}

close user_cursor;
deallocate user_cursor;

declare @total_people int = @total_people1 + @total_people2 + @total_people3 + @total_people4;

print 'Age		Count_persons	%'; 
print '----------------------------------------------------------------------'; 
print ' < 18	' + (cast (@total_people1 as nvarchar(50))) + '			' 
	  + (cast(round(cast(@total_people1 as float)/@total_people*100, 1) as nvarchar(50)));

print '18-24	' + (cast (@total_people2 as nvarchar(50))) + '			' 
	  + (cast(round(cast(@total_people2 as float)/@total_people*100, 1) as nvarchar(50)));

print '24-30	' + (cast (@total_people3 as nvarchar(50))) + '			' 
	  + (cast(round(cast(@total_people3 as float)/@total_people*100, 1) as nvarchar(50)));

print ' > 30	' + (cast (@total_people4 as nvarchar(50))) + '				' 
	  + (cast(round(cast(@total_people4 as float)/@total_people*100, 1) as nvarchar(50)));
print '----------------------------------------------------------------------';
print 'Total:	' + (cast (@total_people as nvarchar(50)))+ '			' 
	  + (cast(round(cast(@total_people as float)/@total_people*100, 1) as nvarchar(50)));

--select * /*max(users.age)*/ from users;	-- ��� �������� ������� �����

-----------------------------------------------------------------------------------------------
--variant 2--


--======================================================================================================
-- 10*. �������� 5 �������������� ���, ����������� � ��������� ������������, � ��, �� ����� ���� ������������

--select * from messages;

declare @current_message nvarchar(255);		-- ������� �����������
declare @word nvarchar(255) = '';			-- ����������� �������� ����� � ��������� ����������
declare @symbol char;						-- �������� ������
declare @symbol_ascii int;					-- ��� ��������� ������� � ������� ascii
	
create table Words (							-- ��������� ������� � ������� � ����������
	ID int identity (1, 1) not null primary key,
	Word nvarchar (50) not null unique,
	Count_word int not null,
);

declare cursor_message cursor for select messages.mess from messages;	-- ���������� �������
open cursor_message;
fetch next from cursor_message into @current_message;					-- ���������� ������� ����������� � ��������� �����

while @@fetch_status = 0					-- ���� ��� ������� �������� ����������
begin

	while len(@current_message) > 0			-- ���� ��� ���������� ������� ��� � �������� ����������
		begin
			set @symbol = substring(@current_message, 1, 1);		-- ����������� ���������� �����������
			set @symbol_ascii = ascii(@symbol);						-- ���������� ���� ������� � ������� ascii
			if ((@symbol_ascii >= 65 and @symbol_ascii <= 90) or (@symbol_ascii >= 97 and @symbol_ascii <= 122) -- �������� ������� �� �� ����� - �������� ��� ��������
				or (@symbol_ascii >= 192 and @symbol_ascii <= 255))
				begin
					set @word += @symbol;					-- ���� �������� ������ - �����, �� ��� ������ ����������� �� �����
					set @current_message = substring(@current_message, 2, len(@current_message) - 1);	-- ��������� ��������� ������� � ��������� �����������
				end

			else											-- ���� �������� ������ - �� ����� 
				begin
					if (@word = '')							-- � ���� ����� �����, ��
						begin
							set @current_message = substring(@current_message, 2, len(@current_message) - 1);	-- �� ������ ��������� ��������� ������� � ��������� �����������
						end
					else									-- ���� �������� ������ - �� ����� � ����� �� �����, �� 
						begin
							if exists(select * from Words where @word in (select Words.Word from Words))	-- ������������ �������� ����� ����� � ������� ���
								begin
									update Words set Count_word += 1 where Words.Word = @word;		-- ���� ���� ��� � � ������� - ������� ���������� �� 1
								end
							else 
								begin
									insert into Words (Word, Count_word) values (@word, 1);			-- ���� ���� ���� � ������� - ������������ ����� ����� � ��� ������
								end
							set @word = '';						-- ��� �� �������� ������ - �� �����, �� ����� �����������
							set @current_message = substring(@current_message, 2, len(@current_message) - 1);	-- � �������� ������ ����������� � ��������� �����������

						end
				end
		end
		if (len(@word) > 0)		-- ���� ���� ������������� ���������� ����������� � ���������� �����, ��
			begin
				if exists(select * from Words where @word in (select Words.Word from Words))	-- ������������ �������� ����� ����� � ������� ���
					begin
						update Words set Count_word += 1 where Words.Word = @word;		-- ���� ���� ��� � � ������� - ������� ���������� �� 1
					end
				else 
					begin
						insert into Words (Word, Count_word) values (@word, 1);			-- ���� ���� ���� � ������� - ������������ ����� ����� � ��� ������
					end
				set @word = '';						-- ��� �� �������� ������ - �� �����, �� ����� �����������
			end
	fetch next from cursor_message into @current_message;		-- ���������� ���������� ����������� � ��������� �����
end

close cursor_message;			-- �������� �������
deallocate cursor_message;

select top 5 * from Words order by Words.Count_word desc;			-- ���������� 5-�� ���, �� ��������� ������������ � ������������

--drop table Words;			-- �������� ������� � ������� � ���� �����
------------------------------------------------------------------------------------
