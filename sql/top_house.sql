-- input a price, and select a room_type from dropdown
-- count the number of top 100 houses in each neighborhood 
-- with the price lower than the inputted price in this room_type
-- that have the number of reviewers 
-- higher than the average number of 
-- reviewers for rooms in this room_type
-- schema: (neighborhood, room_type, num_houses)
-- top 100 houses meeting 
-- requirements in each room_type  
select 
	b.neighborhood as neighborhood, 
	a.room_type as room_type, 
	-- a.accommodates as accommodates, 
	count(a.listing_id) as num_houses 
-- T
from (
	-- -- top 100 houses meeting requirements
	-- -- in each room_type
	select 
		b.listing_id, 
		b.room_type, 
		-- b.accommodates, 
		b.zipcode 
	-- G
	from (
		select 
			a.id as listing_id, 
			a.room_type as room_type, 
			a.review_scores_rating as review_scores_rating, 
			a.zipcode as zipcode, 
			-- a.accommodates as accommodates, 
			a.price as price, 
			count(b.reviewer_id) as num_reviewers
		from airbnb_listing a 
		join reviews_cleaned b 
		on a.id = b.listing_id
		group by listing_id
	) b 
	where 
		-- b.room_type = a.room_type
		b.room_type = "Shared room"
		and 
		b.num_reviewers >= (
			select avg(num_reviewers)
			-- G
			from (
				select 
					a.id as listing_id, 
					a.room_type as room_type, 
					a.review_scores_rating as review_scores_rating, 
					a.zipcode as zipcode, 
					-- a.accommodates as accommodates, 
					a.price as price, 
					count(b.reviewer_id) as num_reviewers
				from airbnb_listing a 
				join reviews_cleaned b 
				on a.id = b.listing_id
				group by listing_id
			) x
			where x.room_type = b.room_type
			-- where room_type = "Shared room"
		)
) a 
join ny_zipcode b 
on a.zipcode = b.zipcode 
group by neighborhood
order by num_houses desc
