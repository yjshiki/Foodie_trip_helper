-- Trusted Reviews: 
-- Input the name of a restaurant 
-- Print top 10 reviews from all trusted users for this restaurant. 
-- A ``trusted user'' is defined as a user: 
-- Has yelping_since before 2017 
-- Has never reviewed a restaurant more than 3 times within one year. 
-- The number of reviews he has given to any restaurant 
-- does not exceed 20% of the total number of reviews given by him. 
-- Has made more than 2 useful reviews
-- (Numbers may be changed according to the data)
-- Schema: (user_name, review)
-- ==> yelp_review2.csv <==
-- "review_id","user_id","business_id","stars","date","text","useful","funny","cool"
select 
	a.user_name as user_name, 
	b.text as review
from yelp_user a
join (
	select 
		b.user_id as user_id, 
		c.business_id as business_id
	from yelp_review2 b
	join yelp_business c 
	on b.business_id = c.business_id
) b 
on a.user_id = b.user_id
where 
	a.yelping_since <= 2017 
	and 0.2 * a.review_count >= all(
		select review_count_business
		from (
			select 
				x.business_id as business_id, 
				count(x.review_id) as review_count_business
			from yelp_review2 x
			where x.user_id = a.user_id
			group by business_id
		)
	)
	and (
		select count(*)
		from yelp_review2 x
		where x.user_id = a.user_id
		and x.useful = 1
	) >= 2
	and 3 >= all(
		select review_count_business 
		from (
			select 
				x.business_id as business_id, 
				extract(year from x.date) as year, 
				count(x.review_id) as review_count_business
			from yelp_review2 x
			where x.user_id = a.user_id
			group by business_id, year
		)
	)
order by length(review) desc, user_name
limit 10;






