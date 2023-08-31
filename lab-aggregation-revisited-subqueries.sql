-- 1.
select distinct c.first_name, c.last_name, c.email from rental r
left join customer c on r.customer_id = c.customer_id
order by email;


-- 2.
select p.customer_id, concat(c.first_name, ' ', c.last_name) customer_name, avg(p.amount) avg_payment from payment p
left join customer c on p.customer_id = c.customer_id
group by p.customer_id
order by avg_payment;


-- 3.1. multiple join statements
select distinct concat(c.first_name, ' ', c.last_name) customer_name, c.email from customer c
join rental r on r.customer_id = c.customer_id
join inventory i on i.inventory_id = r.inventory_id
join film_category fc on fc.film_id = i.film_id
join category cat on cat.category_id = fc.category_id
where cat.name = 'Action'
order by customer_name;


-- 3.2. sub queries with multiple WHERE clause
select concat(first_name, ' ', last_name) customer_name, email from customer
where customer_id in (
	select distinct customer_id from rental
	where inventory_id in (
		select inventory_id from inventory
		where film_id in (
			select film_id from film_category
			where category_id = (
				select category_id from category
				where name = 'Action'
			)
		)
	)
)
order by customer_name;


-- 3.3 Verify above two queries (both have the same counts - 510)
select count(distinct c.email) from customer c
join rental r on r.customer_id = c.customer_id
join inventory i on i.inventory_id = r.inventory_id
join film_category fc on fc.film_id = i.film_id
join category cat on cat.category_id = fc.category_id
where cat.name = 'Action';

select count(email) from customer
where customer_id in (
	select distinct customer_id from rental
	where inventory_id in (
		select inventory_id from inventory
		where film_id in (
			select film_id from film_category
			where category_id = (
				select category_id from category
				where name = 'Action'
			)
		)
	)
);


-- 4.
select payment_id, customer_id, rental_id, amount,
case
	when amount <= 2 then 'low'
    when amount > 2 and amount <= 4 then 'medium'
    else 'high'
end label
from payment;