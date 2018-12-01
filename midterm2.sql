drop trigger if exists dvd_disc_limit on discs;
Create trigger dvd_disc_limit 
before insert or update
on discs
for each row 
execute PROCEDURE rental_limit();

create or replace function disc_limit()
returns trigger as $$
declare
    totaldisc   disc_types.id%type;
begin

Select COUNT(di.id) into totaldisc
from discs di,disc_types dt 
where di.type_id = dt.id and dt.name = 'DVD' and di.movie_id = new.movie_id
group by type_id;

if totaldisc >= 4 then
raise warning 'Not allowed to make more than 3 disc of one movie';
end if;
return new;
end;
$$ language plpgsql;

List the titles of the movies rented by customer John. The results should not contain duplicates.

Select distinct(m.title) as titlename
	from movies m,discs d,rentals r,customers c
	where m.id = d.movie_id and d.id = r.disc_id and r.customer_id = c.id
	and c.name = 'John';

(b) List the titles of the movies rented by both customer John and Jane. The results should not contain duplicates.

Select distinct(m.title) as titlename
	from movies m,discs d,rentals r,customers c
	where m.id = d.movie_id and d.id = r.disc_id and r.customer_id = c.id
	and c.name = 'John'
    intersect
	Select distinct(m.title) as titlename
	from movies m,discs d,rentals r,customers c
	where m.id = d.movie_id and d.id = r.disc_id and r.customer_id = c.id
	and c.name = 'Jane';

(c) Find the highest rated movie based on the average movie rating. 
The result should include the title of the movie and the average rating for the movie. 
If there is a tie, showing one of the movies is enough.

select avg(r.rating) as poprate , m.title as titlename
from  ratings r , movies m 
where m.id = r.movie_id
group by m.title
having avg(r.rating)=
(select max(a.poprate) from(select avg(r.rating) as poprate , m.title as titlename
from  ratings r , movies m 
where m.id = r.movie_id
group by m.title)as a)
limit 1;

