--1) Write a stored function return_disc() that takes a disc id as argument and returns the amount to be charged for the rental.
-- The function should first check the rentals table and see if the disc was rented out but not yet returned. 
--If so, the function sets date_returned to be the current date and sets the available field of the disc to true in the discs table,
-- then returns the amount to be charged based on date_rented, date_returned, and the per-day rental price of the disc. 
--If the rentals table shows that the disc was not rented out or had already been returned, 
--the function outputs a warning message and returns -1.


create or replace function return_disc(discs_id Integer)
	returns float as $$
declare 
	r_rented rentals.date_rented%type;
	r_returned rentals.date_returned%type;
	d_price discs.price%type;
	d_available discs.available%type;
	amount discs.price%type;
	no_of_days integer;
	
begin
	select r.date_rented , r.date_returned into r_rented , r_returned from rentals r , discs d where d.id = r.disc_id and d.id = discs_id;
	if(r_rented is not null and r_returned is not null)then
	
		select (r_returned::date - r_rented::date) , d.price into no_of_days , d_price 
			from rentals r , discs d where d.id = discs_id;
		amount := no_of_days * d_price; 
		
	elsif(r_rented is not null and r_returned is null) then 
		
		select (current_date::date - r_rented::date) , d.price into no_of_days , d_price 
			from rentals r , discs d 
			where d.id = r.disc_id and d.id = discs_id;
		update discs set available = true 
			where id = discs_id;
		update rentals set date_returned = current_date 
			where disc_id = discs_id;
		amount := no_of_days * d_price;
		
	else
		raise warning 'Disc was not rented';
		amount := -1;
	end if;	
	return amount;
end;
$$ language plpgsql;
select return_disc(2);


----------------
--2) Create a trigger rate_only_rented which enforces the constraint that a customer can only rate a movie he or she rented before.

create or replace function rate_only_rented()
returns trigger as $$

declare
l_rental rentals.customer_id%type;
rented integer;

begin

SELECT COUNT(*) INTO rented FROM rentals WHERE disc_id IN
  (SELECT d.id from discs d INNER JOIN 
   rentals r ON r.disc_id = d.id where movie_id = new.movie_id
  AND customer_id = new.customer_id );

   if rented < 1 then
        raise warning 'you have not rented this movie before';
        return null;
  else if rented >0  then
  insert into ratings values (new.customer_id, new.movie_id, new.rating );

  END IF;
end if;
  return null;
end;
$$ language plpgsql;

create trigger rate_only_rented
before insert or update
on ratings
for each row
execute procedure  rate_only_rented();

