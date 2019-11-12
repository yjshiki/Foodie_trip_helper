-- Input the name of a business 
-- Print top 10 reviews from all trusted users for this business. 
-- A ``trusted user'' is defined as a user: 
-- Has yelping_since before 2017 
-- Has never reviewed a business more than 2 times within one year. 
-- The number of reviews he has given to 
-- any business does not exceed 20% of the total number of reviews he has given. 
-- Has made more than 2 useful reviews
-- (Numbers may be changed according to the data)
-- Schema: (user_name, review)
-- ==> yelp_review2.csv <==
-- "review_id","user_id","business_id","stars","date","text","useful","funny","cool"
select 
	a.user_id as user_id, 
	a.name as user_name, 
	b.review as review
from yelp_user a
join (
	select 
		b.user_id as user_id, 
		c.business_id as business_id, 
		b.text as review, 
		c.name as buiness_name
	from yelp_review2 b
	join yelp_business c 
	on b.business_id = c.business_id
) b 
on a.user_id = b.user_id
where 
	b.buiness_name = "Philthy Philly's"
	-- where a.name = "${inputName}"
	and (
		a.yelping_since <= 2017 
		or 0.2 * a.review_count >= all(
			select t.review_count_business
			from (
				select 
					x.business_id as business_id, 
					count(x.review_id) as review_count_business
				from yelp_review2 x 
				where x.user_id = user_id
				group by business_id
			) t
		)
		or (
			select count(*)
			from yelp_review2 x
			where x.user_id = user_id
			and x.useful = 1
		) >= 2
		or 2 >= all(
			select t.review_count_business 
			from (
				select 
					x.business_id as business_id, 
					extract(year from x.date) as year, 
					count(x.review_id) as review_count_business
				from yelp_review2 x
				where x.user_id = user_id
				group by business_id, year
			) t 
		)
	)
order by user_name
limit 100;

