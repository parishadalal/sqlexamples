-- Database: "University"

-- DROP DATABASE "University";

CREATE DATABASE "University"
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'C'
       LC_CTYPE = 'C'
       CONNECTION LIMIT = -1;

--1.List the titles of the courses offered by the Computer Science Department in 2009.

select c.title from courses c , departments d , sections s
	where c.department_id = d.id and c.id = s.course_id
	and d.name ='Computer Science' and s.year = '2009';


--2. List the names of the Computer Science students who graduated in 2009. You must use INNER JOIN for this query.

select stu.name from students stu 
	inner join departments d on d.id = stu.major_id 
	where d.name = 'Computer Science' and extract(year from graduation_date) = 2009;


--3. List the names of the students who took the course Databases.

select distinct stu.name from
	students stu , enrollment e , sections s , courses c 
	where 
	stu.id = e.student_id and e.section_id = s.id
	and s.course_id = c.id and c.title = 'Databases';
	 

--4. List the names of the students who never took the course Databases.

select distinct (stu.name) from students stu where stu.name NOT IN (select distinct(stu.name)
	from students stu,enrollment e
	where e.student_id = stu.id
	and e.section_id in (select s.id
	from courses c,sections s
	where c.id = s.course_id
	and c.title = 'Databases'));

--5. List the names of the students who took both Databases and Compilers.

select distinct stu.name from students stu
	inner join enrollment e on stu.id=e.student_id 
	and e.section_id IN
	(select s.id from sections s , courses c
	where s.course_id = c.id and c.title = 'Databases'
	union select s.id from sections s , courses c
	where s.course_id = c.id and c.title = 'Compilers');

--6. Find the name of the most popular course based on the number of the times the course was offered.

select c.title,count(s.id) as no_of_times_offered 
	from sections s,courses c 
	where s.course_id=c.id 
	group by c.id 
	order by no_of_times_offered 
	desc limit 2;

--7. Find the name of the most popular course based on the total number of students enrolled in the sections of the course.

select distinct c.title,count(e.student_id) as no_of_students 
	from courses c, enrollment e,sections s 
	where e.section_id=s.id and s.course_id=c.id 	
	group by c.id 
	order by no_of_students 
	desc limit 1;

--8. List the professors and the average grade points they gave. Order the results by average grade points in descending order.

select avg(g.value) ,f.name
	from faculty f , grades g ,enrollment e , sections s 
	where e.section_id = s.id and g.id = e.grade_id 
	and f.id = s.instructor_id
	group by f.name
	order by 1 desc;

--9. List the number of students graduated in 2009 by department. The results should show 0 for the departments that do not have any student graduated in 2009.

select count (stu.id ),d.name 
	from students stu right outer join departments d 
	on stu.major_id = d.id and 
	extract (year from stu.graduation_date) = 2009
	group by d.name;

--10. List the students and their major GPA. The results do not need to include the students who have not taken any classes in their major.

select  stu.name , sum(g.value * c.units ) / sum (units)
	from students stu , grades g , enrollment e  , departments d , courses c , sections s 
	where stu.id = e.student_id and stu.major_id = d.id 
	and c.id = s.course_id and c.department_id = d.id 
	and s.id = e.section_id and g.id = e.grade_id 
	group by stu.name;

	
