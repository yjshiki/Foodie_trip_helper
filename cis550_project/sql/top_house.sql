-- input a price, and select a room_type from dropdown
-- count the number of top 100 houses in each neighborhood 
-- with the price lower than the inputted price in this room_type
-- that have the number of reviewers 
-- higher than the average number of 
-- reviewers for rooms in this room_type
-- schema: (neighborhood, room_type, num_houses)
-- top 100 houses meeting 
-- requirements in each room_type 
-- before: 3.28 sec, after: 2.70 sec 
select
	b.neighborhood as neighborhood,
	b.borough as borough,
	count(a.listing_id) as num_houses
from (
	select
		b.listing_id,
		b.room_type,
		b.zipcode,
		b.review_scores_rating
	from (
		select
			a.id as listing_id,
			a.room_type as room_type,
			a.review_scores_rating as review_scores_rating,
			a.zipcode as zipcode,
			a.price as price,
			count(b.reviewer_id) as num_reviewers
		from airbnb_listing a
		join reviews_cleaned b
		on a.id = b.listing_id
		group by listing_id
	) b
	where
		b.room_type = '${type}'
		and
		b.num_reviewers >= (
			select avg(num_reviewers)
			from (
				select
					a.id as listing_id,
					a.room_type as room_type,
					a.review_scores_rating as review_scores_rating,
					a.price as price,
					count(b.reviewer_id) as num_reviewers
				from airbnb_listing a
				join reviews_cleaned b
				on a.id = b.listing_id
				group by listing_id
			) x
			where x.room_type = b.room_type
			and b.price <= '${maxprice}'
		)
	order by review_scores_rating
	limit 100
) a
join ny_zipcode b
on a.zipcode = b.zipcode
group by neighborhood
order by num_houses desc;
