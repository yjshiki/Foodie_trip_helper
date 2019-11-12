-- select a neighborhood
-- print the top 100 reviewers that have reviewed houses 
-- in this neighborhood, as well as their latest comments
-- sort by the number of neighborhoods the reviewer 
-- has reviewed, and then the number of reviews
-- for houses in the inputted neighborhood, 
-- and then the reviewer_name
-- schema: (reviewer_id, reviewer_name, num_neighborhoods, num_reviews)
with G as (
	select 
		a.reviewer_id as reviewer_id, 
		a.reviewer_name as reviewer_name, 
		a.id as review_id, 
		c.neighborhood as neighborhood
	from reviews_cleaned a 
	join airbnb_listing b 
	on b.id = a.listing_id 
	join ny_zipcode c 
	on c.zipcode = b.zipcode 
)
select 
		x.reviewer_id, 
		x.reviewer_name, 
		x.num_neighborhoods, 
		y.num_reviews
from (
	select 
		reviewer_id as reviewer_id, 
		reviewer_name as reviewer_name, 
		count(distinct neighborhood) as num_neighborhoods 
	from G
	group by reviewer_id
) x
join (
	select 
		reviewer_id, 
		count(distinct review_id) as num_reviews
	from G 
	where neighborhood = "Southern Brooklyn"
	group by reviewer_id
) y
on x.reviewer_id = y.reviewer_id
order by num_neighborhoods desc, num_reviews desc, reviewer_name
limit 100;