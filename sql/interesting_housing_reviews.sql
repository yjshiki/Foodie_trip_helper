-- select a neighborhood
-- print the top 100 reviewers that have reviewed houses 
-- in this neighborhood, as well as their latest comment
-- sort by the number of neighborhoods the reviewer 
-- has reviewed, and then the number of reviews
-- for houses in the inputted neighborhood, 
-- and then the reviewer_name
-- schema: (reviewer_id, reviewer_name, num_neighborhoods, num_reviews, latest_comment, latest_date) 
create index reviews 
on reviews_cleaned(reviewer_name, review_date);
select 
	a.reviewer_id as reviewer_id, 
	a.reviewer_name as reviewer_name, 
	a.num_neighborhoods as num_neighborhoods, 
	a.num_reviews as num_reviews, 
	z.comments as latest_comment, 
	z.review_date as latest_date
from (
	select 
		x.reviewer_id, 
		x.reviewer_name, 
		x.num_neighborhoods, 
		y.num_reviews
	from (
		select 
			t.reviewer_id as reviewer_id, 
			t.reviewer_name as reviewer_name, 
			count(distinct t.neighborhood) as num_neighborhoods 
		-- G 
		from (
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
		) t 
		group by reviewer_id
	) x
	join (
		select 
			reviewer_id, 
			count(distinct review_id) as num_reviews
		from (
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
		) t 
		where t.neighborhood = "Southern Brooklyn"
		group by reviewer_id
	) y
	on x.reviewer_id = y.reviewer_id
	order by num_neighborhoods desc, num_reviews desc, reviewer_name
	limit 10
) a
join reviews_cleaned z 
on z.reviewer_id = a.reviewer_id 
where z.review_date = (
	select max(review_date) 
	from reviews_cleaned 
	where reviewer_id = a.reviewer_id
)

