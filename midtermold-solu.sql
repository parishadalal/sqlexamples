--1.
select count(r.disc_id) as rent, m.title 
from movies m , discs d , rentals r 
where m.id = d.movie_id and d.id = r.disc_id 
group by m.title having (count(r.disc_id)<3);

--2.
select count(r.disc_id) as rent , g.name as genrename 
from discs d , movie_genres mg , genres g , rentals r 
where g.id = mg.genre_id and d.id = r.disc_id and d.movie_id = mg.movie_id
group by g.name
having count(r.disc_id)=
(select max(a.rent) from(select count(r.disc_id) as rent , g.name as genrename 
from discs d , movie_genres mg , genres g , rentals r 
where g.id = mg.genre_id and d.id = r.disc_id and d.movie_id = mg.movie_id
group by g.name) as a)
limit 1;

--3.
select avg(r.rating) as poprate , g.name as genrename 
from genres g , movie_genres mg , ratings r , movies m 
where g.id = mg.genre_id and mg.movie_id = m.id and m.id = r.movie_id
group by g.name
having avg(r.rating)=
(select max(a.poprate) from(select avg(r.rating) as poprate , g.name as genrename 
from genres g , movie_genres mg , ratings r , movies m 
where g.id = mg.genre_id and mg.movie_id = m.id and m.id = r.movie_id
group by g.name)as a)
limit 1;



--1
select avg(s.id ) as section , s.year as year
from sections s ,enrollment e 
where s.id = e.section_id 
group by s.year
order by section desc;

--2.
select distinct(f.name)  as professor , count(s.year) as years
from faculty f , sections s , courses c 
where f.id = s.instructor_id and c.id = s.course_id and c.department_id = 10
group by f.name
having (count(s.year)>2);

--3.
select  stu.name , sum(g.value * c.units ) / sum (units)
	from students stu , grades g , enrollment e  , departments d , courses c , sections s 
	where stu.id = e.student_id and stu.major_id = d.id 
	and c.id = s.course_id and c.department_id = d.id 
	and s.id = e.section_id and g.id = e.grade_id and stu.name = 'Joe'
	group by stu.name;
