create index airbnb_reviews
on reviews_cleaned(reviewer_id, reviewer_name, review_date, comments);
create index airbnb 
on airbnb_listing(id, zipcode);