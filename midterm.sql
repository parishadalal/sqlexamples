--1.List the names of the customers who have rented the movie Argo. The results should not contain duplicates.

Select distinct(c.name) as cust_name
	from movies m,discs d,rentals r,customers c
	where m.id = d.movie_id and d.id = r.disc_id and r.customer_id = c.id
	and m.title = 'Argo';

--2.List the names of the customers who have rented the movie Argo more than once. The results should not contain duplicates.

Select distinct(c.name) as cust_name
	from movies m,discs d,rentals r,customers c
	where m.id = d.movie_id and d.id = r.disc_id and r.customer_id = c.id
	and m.title = 'Argo'
	Group by c.name
	Having COUNT(r.id) > 1;


--3.Find the customer who have rated the most number of movies. The result should include the name of the customer and 
--the number of movies he or she rated. If there is a tie, showing one of the customers is enough.

Select COUNT(r.movie_id) as totalmovie,c.name as cust_name
	from customers c,ratings r
	where r.customer_id = c.id
	Group by c.name
	Order by 1 desc
	limit 1;


--Create a trigger rental_disc_limit which enforces the constraint that a customer can rent at most three discs at any time.

drop trigger if exists rental_disc_limit on rentals;

create trigger rental_disc_limit 
before insert or update
on rentals
for each row 
execute procedure rental_limit();


create or replace function rental_limit()
	returns trigger as $$

declare
	r_discid    rentals.disc_id%type;

begin
	select r.disc_id into r_discid from rentals r , discs d
		where r.disc_id= d.id and d.id = new.disc_id;
	if(select count(*) from rentals where r_discid = new.disc_id)> 3
		then
		raise warning 'Cannot rent more';
	end if;
	return new;

end;
$$language plpgsql;


