-- input a price
-- count the number of top 100 houses in each neighborhood 
-- with the price lower than the inputted price in each room_type
-- that have the number of reviewers 
-- higher than the average number of 
-- reviewers for rooms in this room_type
-- schema: (neighborhood, room_type, num_houses)
-- top 100 houses meeting 
-- requirements in each room_type  
with T as (
	-- num_reviewers for each house
	with G as (
		select 
			a.id as listing_id, 
			a.room_type as room_type, 
			a.property_type as property_type, 
			a.review_scores_rating as review_scores_rating, 
			a.zipcode as zipcode, 
			a.price as price, 
			count(b.reviewer_id) as num_reviewers
		from airbnb_listing a 
		join reviews_cleaned b 
		on a.id = b.listing_id
		group by listing_id
	)
	select 
		a.listing_id as listing_id, 
		a.zipcode as zipcode, 
		a.room_type as room_type, 
		a.review_scores_rating as review_scores_rating, 
		a.num_reviewers as num_reviewers, 
		a.price as price
	from G a
	-- top 100 houses meeting requirements
	-- in each room_type
	inner join (
		select b.listing_id 
		from G b 
		where 
			b.room_type = room_type
			-- b.room_type = "Shared room"
			and 
			b.num_reviewers >= (
				select avg(num_reviewers)
				from G 
				where room_type = b.room_type
				-- where room_type = "Shared room"
			)
			-- and b.price <= "${inputPrice}"
			and b.price <= 800 
		order by 
			b.review_scores_rating desc, 
			b.num_reviewers desc, 
			b.price 
		limit 100
	) t 
	on t.listing_id = a.listing_id
)
select 
	b.neighborhood as neighborhood, 
	a.room_type as room_type, 
	count(a.listing_id) as num_houses 
from T a 
join ny_zipcode b 
on a.zipcode = b.zipcode 
group by neighborhood, room_type 

