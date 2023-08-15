use sakila;

-- Select the first name, last name, and email address of all the customers who have rented a movie.

select distinct c.first_name, c.last_name, c.email
from sakila.customer c
join rental r using (customer_id);

-- What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

select distinct concat(c.first_name, " ", c.last_name) as "customer name", c.email, round(avg(p.amount),2) as "average_payment" from payment p
join customer c using (customer_id)
group by c.customer_id;

-- Select the name and email address of all the customers who have rented the "Action" movies.
-- Write the query using multiple join statements

select distinct c.first_name, c.last_name, c.email from sakila.customer c
join sakila.rental r using (customer_id)
join sakila.inventory i using (inventory_id)
join sakila.film f using (film_id)
join sakila.film_category fc using (film_id)
join sakila.category ct using (category_id)
where ct.name = "Action";

-- Write the query using sub queries with multiple WHERE clause and IN condition

SELECT first_name, last_name, email
FROM sakila.customer
WHERE customer_id IN (
    SELECT DISTINCT r.customer_id
    FROM sakila.rental r
    WHERE r.inventory_id IN (
        SELECT i.inventory_id
        FROM sakila.inventory i
        WHERE i.film_id IN (
            SELECT f.film_id
            FROM sakila.film f
            WHERE f.film_id IN (
                SELECT film_id
                FROM sakila.film_category
                WHERE category_id = (
                    SELECT category_id
                    FROM sakila.category
                    WHERE name = 'Action'
                )
            )
        )
    )
);

-- Verify if the above two queries produce the same results or not
-- Yes, both return 510 rows

-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
-- case when amount > 2 then low 

select *, 
	case
		when amount >= 0 and amount <=2 then "low"
        when amount > 2 and amount <=4 then "medium"
        when amount > 4 then "high"
	end 
    as transaction_value
from payment;