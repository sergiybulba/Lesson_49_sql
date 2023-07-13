--  1) Розгорнути БД Dating
--   done

--  2) У всіх завданнях (крім 9 та 10) інформацію про користувачів необхідно показувати у такому вигляді:
--  - унікальний номер сторінки користувача в соціальній мережі
--  - нік
--  - вік
--  - стать
--  + додаткові поля, вказані у запиті.
--  ok

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--======================================================================================================

-- 1. Показати TOP-10 користувачів з найвищим середнім рейтингом анкети (Anketa_Rate, AVG, 
--    середній рейтинг має бути представлений у вигляді дійсного числа)

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
-- 2. Показати всіх користувачів з вищою освітою, які не курять, не п'ють та не вживають наркотики

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

/*select users.user_id as User_unique_ID,	-- для перевірки
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
-- 3. Зробити запит, який дозволить знайти користувачів за вказаними даними:
--    - нік (не обов'язково точний)
--    - стать
--    - мінімальний та максимальний вік
--    - мінімальне та максимальне зріст
--    - мінімальна та максимальна вага

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
-- 4. Показати всіх струнких блакитнооких блондинок, потім усіх спортивних карооких брюнетів, 
--    а в кінці їх загальна кількість (UNION, одним запитом на SELECT)

/*select * from haircolor		-- 1 - блонд, 4 - брюнет
select * from eyescolor		-- 4 - блакитні, 2 - карі очі
select * from figure		-- 2 - стрункі, 4 - спортивні*/

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
-- загальна кількість рядків у попередній вибірці (як можна це об'єднати в одному запиті?)

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
-- 5. Показати всіх програмістів з пірсингом, які до того ж вміють вишивати хрестиком (Moles, Framework та Interes)

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

/*select users.user_id as User_unique_ID,	-- для перевірки
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
-- 6. Показати скільки подарунків подарували кожному користувачу, який має знак зодіаку Риби

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

/*select users.user_id as User_unique_ID,	-- для перевірки
	   users.nick as User_nick,
	   users.age as User_age,
	   users.sex as User_sex,
	   gift_service.id_to as Gift
	   
from users, gift_service
where users.user_id = gift_service.id_to and gift_service.id_to = 31459214; */

--======================================================================================================
-- 7. Показати як багато заробляють собі на життя поліглоти (які знають більше 5 мов), які зовсім не вміють готувати

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
-- 8. Показати всіх буддистів, які займаються східними єдиноборствами, живуть на вокзалі, 
--    та у вільний час катаються на скейті

/*select * from religion	-- 6 - буддизм
select * from residence		-- 9 - вокзал
select * from sport 		-- 6 - скейтборд, 9 - єдиноборства
select * from interes*/

select users.user_id as User_unique_ID,		-- відсутні такі люди ?
	   users.nick as User_nick,
	   users.age as User_age,
	   gender.name as User_sex
from users inner join gender on users.sex = gender.id
		   inner join religion on users.religion = religion.id
		   inner join residence on users.rec_mess = residence.id
		   inner join users_sport on users.user_id = users_sport.user_id
		   inner join sport on sport.id = users_sport.sport_id

where religion.id = 6 and residence.id = 9 and (sport.id = 6 or sport.id = 9);


/*select users.user_id as User_unique_ID,			-- перевірка: буддист і живе на вокзалі - знайдено лише одну людину,
	   users.nick as User_nick,						-- якщо додати спорт - таких людей немає
	   users.age as User_age,
	   gender.name as User_sex
from users inner join gender on users.sex = gender.id
		   inner join residence on users.rec_mess = residence.id
		   inner join religion on users.religion = religion.id

where religion.id = 6 and residence.id = 9; */

--======================================================================================================
-- 9. Показати вікову аудиторію користувачів у вигляді:
   /* вік у %:   до 18 2000 40.0
				 18-24 1500 30.0
				 24-30 1000 20.0
				від 30  500 10.0 */

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

--select * /*max(users.age)*/ from users;	-- для перевірки кількості людей

-----------------------------------------------------------------------------------------------
--variant 2--


--======================================================================================================
-- 10*. Показати 5 найпопулярніших слів, відправлених у особистих повідомленнях, і те, як часто вони зустрічаються

--select * from messages;

declare @current_message nvarchar(255);		-- поточне повідомлення
declare @word nvarchar(255) = '';			-- витягування окремого слова з поточного повідомленя
declare @symbol char;						-- поточний символ
declare @symbol_ascii int;					-- код поточного символу в таблиці ascii
	
create table Words (							-- створення таблиці зі словами з повідомлень
	ID int identity (1, 1) not null primary key,
	Word nvarchar (50) not null unique,
	Count_word int not null,
);

declare cursor_message cursor for select messages.mess from messages;	-- оголошення курсору
open cursor_message;
fetch next from cursor_message into @current_message;					-- зчитування першого повідомлення в тимчасову змінну

while @@fetch_status = 0					-- цикл для обробки поточних повідомлень
begin

	while len(@current_message) > 0			-- цикл для формування окремих слів з поточних повідомлень
		begin
			set @symbol = substring(@current_message, 1, 1);		-- посимвольне зчитування повідомлення
			set @symbol_ascii = ascii(@symbol);						-- визначення коду символу в таблиці ascii
			if ((@symbol_ascii >= 65 and @symbol_ascii <= 90) or (@symbol_ascii >= 97 and @symbol_ascii <= 122) -- перевірка символу чи це літера - латиниця або кирилиця
				or (@symbol_ascii >= 192 and @symbol_ascii <= 255))
				begin
					set @word += @symbol;					-- якщо поточний символ - літера, то цей символ добавляться до слова
					set @current_message = substring(@current_message, 2, len(@current_message) - 1);	-- видалення зчитаного символа з поточного повідомлення
				end

			else											-- якщо поточний символ - не літера 
				begin
					if (@word = '')							-- і якщо слово пусте, то
						begin
							set @current_message = substring(@current_message, 2, len(@current_message) - 1);	-- то просто видалення зчитаного символа з поточного повідомлення
						end
					else									-- якщо поточний символ - не літера і слово не пусте, то 
						begin
							if exists(select * from Words where @word in (select Words.Word from Words))	-- перевіряється наявність цього слова в таблиці слів
								begin
									update Words set Count_word += 1 where Words.Word = @word;		-- якщо воно вже є в таблиці - кількість збільшується на 1
								end
							else 
								begin
									insert into Words (Word, Count_word) values (@word, 1);			-- якщо його немає в таблиці - вставляється новий рядок з цим словом
								end
							set @word = '';						-- так як поточний символ - не літера, то слово обнуляється
							set @current_message = substring(@current_message, 2, len(@current_message) - 1);	-- і зчитаний символ видаляється з поточного повідомлення

						end
				end
		end
		if (len(@word) > 0)		-- якщо після посимвольного зчитування повідомлення є сформоване слово, то
			begin
				if exists(select * from Words where @word in (select Words.Word from Words))	-- перевіряється наявність цього слова в таблиці слів
					begin
						update Words set Count_word += 1 where Words.Word = @word;		-- якщо воно вже є в таблиці - кількість збільшується на 1
					end
				else 
					begin
						insert into Words (Word, Count_word) values (@word, 1);			-- якщо його немає в таблиці - вставляється новий рядок з цим словом
					end
				set @word = '';						-- так як поточний символ - не літера, то слово обнуляється
			end
	fetch next from cursor_message into @current_message;		-- зчитування наступного повідомлення в тимчасову змінну
end

close cursor_message;			-- закриття курсору
deallocate cursor_message;

select top 5 * from Words order by Words.Count_word desc;			-- формування 5-ти слів, які найчастіше зустрічаються в повідомленнях

--drop table Words;			-- видалити таблицю зі словами з бази даних
------------------------------------------------------------------------------------
