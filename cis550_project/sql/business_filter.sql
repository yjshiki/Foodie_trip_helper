-- Input a name of a business  
-- Print top 3 open restaurants 
-- that have all the categories of the 
-- user-inputted restaurant. The 
-- result should exclude the restaurant that was input. 
-- Order first by highest “stars”, then 
-- highest “review_count” of restaurants, 
-- Schema: (business_id, business_name, stars, review_count)
-- before: > 4 h, after: 0.54 sec
select distinct
  	a.business_id as business_id,
  	a.name as business_name,
  	a.stars as stars,
  	a.review_count as review_count
  from yelp_business a
  where (
  	not(exists(
  		select t.category
  		from (
  			select b.category
  			from yelp_categories b
  			join yelp_business a
  			on b.business_id = a.business_id
  			where a.name = '${myBusinesses}'
  			limit 1000000000000000
  		) t
  		where t.category != all(
  			select distinct b.category
  			from yelp_categories b
  			where a.business_id = b.business_id
  		)
  	))
  ) and a.name != '${myBusinesses}'
  and a.is_open = 1
  order by stars desc, review_count desc, business_name
  limit 3;





