-- input a price
-- count the number of top 100 houses in each neighborhood 
-- with the price lower than the inputted price in each room_type
-- that have the number of reviewers 
-- higher than the average number of 
-- reviewers for rooms in this room_type
-- schema: (neighborhood, room_type, num_houses)
-- top 100 houses in each 
-- room_type and meeting requirements 
with T as (
	-- num_reviewers for each house
	with G as (
		select 
			a.id as house_id, 
			a.zipcode as zipcode, 
			a.room_type as room_type, 
			a.review_score_rating as review_score_rating, 
			count(b.reviewer_id) as num_reviewers
		from airbnb_listing a 
		join reviews_cleaned b 
		on a.id = b.id
		group by house_id
	)
	select 
		a.house_id as house_id, 
		a.zipcode as zipcode, 
		a.room_type as room_type
	from G a 
	-- top 100 houses meeting requirements
	-- in each room_type
	where a.house_id in (
		select b.house_id
		from G b 
		where 
			b.room_type = a.room_type
			and 
			b.num_reviewers >= (
				select avg(num_reviewers)
				from G 
				where room_type = b.room_type
			)
			-- and b.price <= "${inputPrice}"
			and b.price <= 800 
		order by review_score_rating desc, num_reviewers desc
		limit 100
	)
)
select 
	b.neighborhood as neighborhood, 
	a.room_type as room_type, 
	count(a.house_id) as num_houses 
from T a 
join ny_zipcode b 
on a.zipcode = b.zipcode 
group by neighborhood, room_type

