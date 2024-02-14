use mavenmovies;
-- QUESTION-1. First Normal Form(1NF)
-- Q. identify a table in the sakila database that violates 1NF.
-- Ans:- the film table violates the First Normal Form (1NF) due to the "special_features" column, 
-- 		which contains multiple values separated by commas. 
-- 		This violates the atomicity rule of 1NF, which requires that each column must contain atomic values.
-- -----------------
-- Q. Explain how you would normalize it to achieve 1NF.
-- Ans:- To achieve 1NF, we need to normalize the film table by removing the "special_features" column and
-- 		Create a new table with columns 'film_id' and 'special_feature' to store the special features separately.


-- ---------------------------------------------------------------------------------------------
-- QUESTION-2. SECOND NORMAL FORM(2NF)
-- Q. choose a table in sakila and describe how you would determine whether it is in 2NF. 
-- if it violates 2NF, explain the steps to normalize it. 
SELECT * FROM payment;
-- In this example, the payment table includes columns such as customer_id, staff_id, and rental_id.
-- To determine whether the table is in Second Normal Form (2NF) , we need to check for partial dependencies.
 
 -- Partial_dependency_Check
--  Identify if any attributes depend on only a part of the primary key.
 -- In this case, 'amount' depends only on "rental_id", and "payment_date" depends on "payment_id".
 -- These dependencies suggest a violation of 2NF.
--  
--  payment_id | customet_id | staff_id | rental_id | amount | payment_date
-- -----------------------------------------------------------------------------
--     1       |     1       |     1     |   76     |  2.99  | 2005-05-25
-- 	2       |     1       |     1     |  573     |  0.99  | 2005-05-28
--     3       |     1       |     1     |  1185    |  5.99  | 2005-06-15
--     4       |     1       |     2     |  1422    |  0.99  | 2005-06-15
--     5       |     1       |     2     |  1185    |  9.99  | 2005-06-15

 --  Steps to Normalize :
-- 1) Identify the redundancy we want to remove data_repetation 
-- 2) Establish relationships between the tables.
--  
-- Normalized 'payment_details' table:
-- payment_id | rental_id | amount | payment_date
-- --------------------------------------------------
--    1      |  76        | 2.99   | 2005-05-25
--    2      |  573       | 0.99   | 2005-05-28
--    3      |  1185      | 5.99   | 2005-06-15
--    4      |  1422      | 0.50   | 2005-06-15
--    5      |  1185      | 9.99   | 2005-06-15


-- Normalized 'payment_customer' table:
--  payment_id | customet_id 
-- -----------------------------
--     1       |     1      
-- 	2       |     1      
--     3       |     1      
--     4       |     1     
--     5       |     1      

-- Normalized 'payment_staff' table:
--  payment_id |satff_id 
-- ---------------------------
--     1       |     1      
-- 	2       |     1      
--     3       |     1      
--     4       |     2     
--     5       |     2
--     
-- In this normalization, 
-- 1)  payment_details table has information directly related to payments
-- 2)  payment_customer table has information related to payment & customer
-- 3)  payment_staff table has information reltaed to payment & staff.
-- 4)  This separation ensures that each table has a clear and independent purpose, reducing redundancy and improving the overall database structure.

--------------------------------------------------------------------------------------------------------- 
 -- QUESTION-3. Third Normal Form (3NF)
-- Identify a table in Sakila that violates 3NF. 
-- Describe the transitive dependencies present and outline the steps to normalize the table to 3NF

-- emp table:
-- emp_id | emp_name       | manager_id
-- ----------------------------------------
-- 1      | John Doe       | Null
-- 2      | Alice Smith    | 1
-- 3      | Bobby Johnson  | 1
-- 4      | Charlie Brown  | 2
-- 5      | Evan Gracia    | 2

-- Steps to Normalize to 3NF:
-- 1) Create a 'manager' table: As in sakila database their is no Mangaer table
-- manager_id | manager_name
-- ----------------------------
--     1      | Maria Chan
--     2      | Carol Wong
--     
-- 2) Modify the emp table:
-- emp_id | emp_name       | manager_id
-- ----------------------------------------
-- 1      | John Doe       | Null
-- 2      | Alice Smith    | 1
-- 3      | Bobby Johnson  | 1
-- 4      | Charlie Brown  | 2
-- 5      | Evan Gracia    | 2

-- Now, the emp_table is in 3NF. The manager_id column is no longer transitively dependent on the emp_id because it directly references the primary key of the manager table.

-- -------------------------------------------------------------------------------------------


-- QUESTION-4. Normalization Process
--  Take a specific table in Sakila and guide through the process of normalizing it from the initial unnormalized form up to at least 2NF
    
SELECT * FROM emp;
-- - In "emp" table has column such as emp_id , emp_name , manager_id 

-- Initial Unnormalized Form (emp table):

-- emp_id | emp_name       | manager_id
---------------------------------------
-- 1      | John Doe       | Null
-- 2      | Alice Smith    | 1
-- 3      | Bobby Johnson  | 1
-- 4      | Charlie Brown  | 2
-- 5      | Evan Gracia    | 2

-- Steps to Normalize to 1NF:
-- 1) Identify atomic values in each column: 
-- In this table, all columns seem to contain atomic values, and there are no multiple values present.

-- 2) Identify a primary key: 
-- The emp_id column is a primary key as it uniquely identifies each employee.
--  Now, table is in First Normal Form (1NF).
 
  -- Steps to Normalize to 2NF: 
-- 1) Identify partial dependencies:
-- Check if there are partial dependencies.
-- -- In this table, there is a potential partial dependency. The manager_id column is dependent on the emp_id, which is part of the primary key. 
-- -- Create new table for 'Manager'.

-- 2) Create 'manager' table:
--  manager_id | manager_name
-- -----------------------------
--     1       |  Maria Chan
--     2       |  Carol Wong


-- 3) Modify the emp table:
-- emp_id | emp_name       | manager_id
-- ----------------------------------------
-- 1      | John Doe       | Null
-- 2      | Alice Smith    | 1
-- 3      | Bobby Johnson  | 1
-- 4      | Charlie Brown  | 2
-- 5      | Evan Gracia    | 2

-- This separation ensures that each table has a clear and independent purpose. 
-- reducing redundancy and improving the overall database structure.
-- ------------------------------------------------------------------------


-- QUESTION-5. CTE BASICS
-- write a query using a cte to retrieve the distinct list of actor names and the number of films they have acted
-- in from the actor and film_actor tables.

with ActorFilm as(
select actor.actor_id,concat(actor.first_name,' ',actor.last_name) as actor_name,film_actor.film_id
from actor join film_actor on actor.actor_id = film_actor.actor_id
)
select distinct actor_id,actor_name,count(film_id) as number_of_films from ActorFilm
group by actor_id order by number_of_films desc;

-- -------------------------------------------------------------------------------------------------

-- QUESTION-6. RECURSIVE CTE
-- Use a recursive cte to generate a hirarchical list of categories 
-- and their subcategories from the category table in sakila.

-- there is no 'subcategories' column exist in sakila database. 

-- --------------------------------------------------------------------------------------------
-- QUESTION-7. CTE WITH JOINS
-- creare a cte that combines information from film and language tables to display the film title,
-- language name and rental_rate.

with FilmLanguage as (
select film.film_id,film.title,film.rental_rate,language.language_id,language.name as language_name from language
join film on language.language_id = film.language_id
)
select title,language_name,rental_rate from FilmLanguage;

-- -----------------------------------------------------------------------------------------
-- QUESTION-8. CTE FOR AGGREGATION
-- write a query using a cte to find the total revenue generated by each customer(sum of payments)
--  from the customer and payments tables.
with CustomerRevenue as(
select payment.customer_id,concat(customer.first_name,' ',customer.last_name) as customer_names,
sum(payment.amount) as revenue from customer
join payment on customer.customer_id = payment.customer_id
group by payment.customer_id 
)
select customer_id,customer_names,revenue from CustomerRevenue order by revenue desc;


-- ----------------------------------------------------------------------------
-- QUESTION-9. CTE WITH WINDOW FUNCTIONS:
-- utilize a cte with a window function to rank films based on their rental duration from the film table.

with FilmRank as(
select film_id,title,rental_duration,rank() over( order by rental_duration desc) as rental_duration_rank 
FROM film
)
select film_id,title,rental_duration,rental_duration_rank from FilmRank ;

-- --------------------------------------------------------------------------------------------
--  QUESTION-10. CTE AND FILTERING:
-- create a cte to list customers who have made more than two rentals, and then join this cte with the customer
-- table to retreive additional customer details.

with RentalCount as(
select customer_id,count(rental_id) as rental_count from rental
group by customer_id 
having rental_count > 2 
)
select rental_count,customer.* from RentalCount join customer on RentalCount.customer_id = customer.customer_id
order by rental_count;

-- ------------------------------------------------------------------------------------------
-- QUESTION-11. CTE FOR DATE CALCULATIONS:
-- write a query using a cte to find the total number of rentals made each month, considering the rental_date
-- from the rental table.
with CountRental as (
select rental_id,concat(year(rental_date),'-',monthname(rental_date)) as Month from rental 
)
select count(rental_id) as Rentals,Month from CountRental group by Month ;

-- --------------------------------------------------------------------------------------
-- QUESTION-12. CTE FOR PIVOT OPERATIONS:
-- use a cte to pivot the data from the payment table to display the total payments made by each customer
--  in separate column for different payments method.

WITH PaymentMethod AS (
SELECT customer_id, COUNT(amount) AS total_number_of_payments, 
COUNT(DISTINCT amount) AS distinct_payment_methods
FROM payment GROUP BY customer_id 
)
SELECT customer_id,total_number_of_payments,distinct_payment_methods FROM PaymentMethod 
ORDER BY distinct_payment_methods;
-- In sakila database,there dont have any specific column for payment method, 
-- that's why i make this type of output based on "distinct payment amount".

-- ---------------------------------------------------------------------------------------
-- QUESTION-13. CTE AND SELF JOIN:
-- create a cte to generate a report showing pairs of actors who have appeared in the same film together,
-- using the film_actor table.

WITH ActorPairs AS (
SELECT fa1.actor_id AS actor1_id, fa2.actor_id AS actor2_id, f.title AS film_title
FROM film_actor fa1
INNER JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
INNER JOIN film f ON fa1.film_id = f.film_id
)
SELECT actor1_id,actor2_id,film_title FROM ActorPairs;


-- -------------------------------------------------------------------------------------
-- QUESTION-14. CTE FOR RECURSIVE SEARCH:
-- implement a recursive cte to find all employees in the staff table who report to specific manager,
-- considering to the reports_to column.




















