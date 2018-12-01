# sqlexamples
This repository contains different sql examples 

# ex4-create.sql
This sql writes a stored function return_disc() that takes a disc id as argument and returns the amount to be charged for the rental. The function should first check the rentals table and see if the disc was rented out but not yet returned.  If so, the function sets date_returned to be the current date and sets the available field of the disc to true in the discs table, then returns the amount to be charged based on date_rented, date_returned, and the per-day rental price of the disc. If the rentals table shows that the disc was not rented out or had already been returned, the function outputs a warning message and returns -1.

# midterm.sql
This sql query does the following:
  List the names of the customers who have rented the movie Argo. The results should not contain duplicates.
  List the names of the customers who have rented the movie Argo more than once. The results should not contain duplicates.
  Find the customer who have rated the most number of movies. The result should include the name of the customer and the   number of movies he or she rated. If there is a tie, showing one of the customers is enough.
  Create a trigger rental_disc_limit which enforces the constraint that a customer can rent at most three discs at any time.

# hw2-queries.sql
This sql query contains database for University. 
 --1.List the titles of the courses offered by the Computer Science Department in 2009.
 --2. List the names of the Computer Science students who graduated in 2009. You must use INNER JOIN for this query.
 --3. List the names of the students who took the course Databases. 
 --4. List the names of the students who never took the course Databases. 
 --5. List the names of the students who took both Databases and Compilers.
 --6. Find the name of the most popular course based on the number of the times the course was offered.
 --7. Find the name of the most popular course based on the total number of students enrolled in the sections of the course.
 --8. List the professors and the average grade points they gave. Order the results by average grade points in descending order.
 --9. List the number of students graduated in 2009 by department. The results should show 0 for the departments that do not have any student graduated in 2009.
 --10. List the students and their major GPA. The results do not need to include the students who have not taken any classes in their major.





  
