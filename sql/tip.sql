-- Input a name of a restaurant, select start_date and end_date in a drop-down and input a keyword
-- Print all tips (short reviews) containing the user-inputted keyword between 
-- chosen dates for top 5 open restaurants that have all the categories of the 
-- user-inputted restaurant, from all users giving stars to this restaurant 
-- higher than his average_stars. The result should exclude the restaurant that was input. 
-- Order first by highest “stars”, then highest “review_count” of restaurants, 
-- the date of the tip descendingly, and then the user_name. 
-- Schema: (business_id, business_name, user_id, user_name, tip, date, stars, review_count)
-- selected businesses
with Businesses as (
	-- genres of the input business
	with G as (
		select b.category  
		from yelp_categories b
		join yelp_business a
		on b.business_id = a.business_id 
		-- where a.name = "${inputName}"
		where a.name = "Dental by Design"
	)
	select distinct 
		a.business_id as business_id, 
		a.name as business_name, 
		a.stars as stars, 
		a.review_count as review_count
	from yelp_business a
	-- if G is a subset of (genres of a) 
	where (
		not(exists(
			select category 
			from G 
			where category != all(
				select b.category 
				from yelp_categories b 
				join (
					select * 
					from yelp_business x
					where x.business_id = business_id
				) c
				on b.business_id = c.business_id 
				where a.business_id = c.business_id
			)
		))
	-- ) and a.name != "${inputName}"
	) and a.name != "Dental by Design"
	order by stars desc, review_count desc, business_name
	limit 5
)
select distinct 
	a.business_id as business_id, 
	a.name as business_name, 
	b.user_id as user_id, 
	b.user_name as user_name, 
	b.tip as tip, 
	a.stars as stars, 
	a.review_count as review_count
from Businesses a
join (
	select 
		t.user_id as user_id, 
		t.text as tip, 
		x.name as user_name
	from yelp_tip t
	join yelp_user x
	on t.user_id = x.user_id
) b
on a.business_id = b.business_id
order by stars desc, review_count desc, date desc, user_name;

