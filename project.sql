--==> zipcode <==--
CREATE TABLE zipcode{
    zipcode VARCHAR(255),
    borough VARCHAR(255),
    neighborhood VARCHAR(255),
    PRIMARY KEY(zipcode)
};
--Schema of Yelp Data: 
--==> yelp_business.csv <==
--business_id,name,neighborhood,address,city,state,postal_code,latitude,longitude,stars,review_count,is_open,categories

CREATE TABLE yelp_business{
    business_id VARCHAR(255),
    name VARCHAR(255),
    neighborhood VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postal_code VARCHAR(255),
    latitude decimal(10.8),
    longitude decimal(10.8),
    stars decimal(10.3),
    review_count int(10),
    is_open int(10),
    categories VARCHAR(255),
    PRIMARY KEY(business_id),
    FOREIGN KEY(postal_code) REFERENCES zipcode(zipcode)
};


--==> yelp_categories.csv <==
--id,category
CREATE TABLE yelp_categories{
    id VARCHAR(255),
    category VARCHAR(255),
    PRIMARY KEY(id),
    FOREIGN KEY (id) REFERENCES yelp_business(business_id)
};

--==> yelp_business_attributes.csv <==
--business_id,AcceptsInsurance,ByAppointmentOnly,BusinessAcceptsCreditCards,BusinessParking_garage,BusinessParking_street,BusinessParking_validated,BusinessParking_lot,BusinessParking_valet,HairSpecializesIn_coloring,HairSpecializesIn_africanamerican,HairSpecializesIn_curly,HairSpecializesIn_perms,HairSpecializesIn_kids,HairSpecializesIn_extensions,HairSpecializesIn_asian,HairSpecializesIn_straightperms,RestaurantsPriceRange2,GoodForKids,WheelchairAccessible,BikeParking,Alcohol,HasTV,NoiseLevel,RestaurantsAttire,Music_dj,Music_background_music,Music_no_music,Music_karaoke,Music_live,Music_video,Music_jukebox,Ambience_romantic,Ambience_intimate,Ambience_classy,Ambience_hipster,Ambience_divey,Ambience_touristy,Ambience_trendy,Ambience_upscale,Ambience_casual,RestaurantsGoodForGroups,Caters,WiFi,RestaurantsReservations,RestaurantsTakeOut,HappyHour,GoodForDancing,RestaurantsTableService,OutdoorSeating,RestaurantsDelivery,BestNights_monday,BestNights_tuesday,BestNights_friday,BestNights_wednesday,BestNights_thursday,BestNights_sunday,BestNights_saturday,GoodForMeal_dessert,GoodForMeal_latenight,GoodForMeal_lunch,GoodForMeal_dinner,GoodForMeal_breakfast,GoodForMeal_brunch,CoatCheck,Smoking,DriveThru,DogsAllowed,BusinessAcceptsBitcoin,Open24Hours,BYOBCorkage,BYOB,Corkage,DietaryRestrictions_dairy-free,DietaryRestrictions_gluten-free,DietaryRestrictions_vegan,DietaryRestrictions_kosher,DietaryRestrictions_halal,DietaryRestrictions_soy-free,DietaryRestrictions_vegetarian,AgesAllowed,RestaurantsCounterService
CREATE TABLE yelp_business_attributes{
    business_id VARCHAR(255),
    AcceptsInsurance VARCHAR(255),
    ByAppointmentOnly VARCHAR(255),
    BusinessAcceptsCreditCards VARCHAR(255),
    BusinessParking_garage VARCHAR(255),
    BusinessParking_street VARCHAR(255),
    BusinessParking_validated VARCHAR(255),
    BusinessParking_lot VARCHAR(255),
    BusinessParking_valet VARCHAR(255),
    HairSpecializesIn_coloring VARCHAR(255),
    HairSpecializesIn_africanamerican VARCHAR(255),
    HairSpecializesIn_curly VARCHAR(255),
    HairSpecializesIn_perms VARCHAR(255),
    HairSpecializesIn_kids VARCHAR(255),
    HairSpecializesIn_extensions VARCHAR(255),
    HairSpecializesIn_asian VARCHAR(255),
    HairSpecializesIn_straightperms VARCHAR(255),
    RestaurantsPriceRange2 VARCHAR(255),
    GoodForKids VARCHAR(255),
    WheelchairAccessible VARCHAR(255),
    BikeParking VARCHAR(255),
    Alcohol VARCHAR(255),
    HasTV VARCHAR(255),
    NoiseLevel VARCHAR(255),
    RestaurantsAttire VARCHAR(255),
    Music_dj VARCHAR(255),
    Music_background_music VARCHAR(255),
    Music_no_music VARCHAR(255),
    Music_karaoke VARCHAR(255),
    Music_live VARCHAR(255),
    Music_video VARCHAR(255),
    Music_jukebox VARCHAR(255),
    Ambience_romantic VARCHAR(255),
    Ambience_intimate VARCHAR(255),
    Ambience_classy VARCHAR(255),
    Ambience_hipster VARCHAR(255),
    Ambience_divey VARCHAR(255),
    Ambience_touristy VARCHAR(255),
    Ambience_trendy VARCHAR(255),
    Ambience_upscale VARCHAR(255),
    Ambience_casual VARCHAR(255),
    RestaurantsGoodForGroups VARCHAR(255),
    Caters VARCHAR(255),
    WiFi VARCHAR(255),
    RestaurantsReservations VARCHAR(255),
    RestaurantsTakeOut VARCHAR(255),
    HappyHour VARCHAR(255),
    GoodForDancing VARCHAR(255),
    RestaurantsTableService VARCHAR(255),
    OutdoorSeating VARCHAR(255),
    RestaurantsDelivery VARCHAR(255),
    BestNights_monday VARCHAR(255),
    BestNights_tuesday VARCHAR(255),
    BestNights_friday VARCHAR(255),
    BestNights_wednesday VARCHAR(255),
    BestNights_thursday VARCHAR(255),
    BestNights_sunday VARCHAR(255),
    BestNights_saturday VARCHAR(255),
    GoodForMeal_dessert VARCHAR(255),
    GoodForMeal_latenight VARCHAR(255),
    GoodForMeal_lunch VARCHAR(255),
    GoodForMeal_dinner VARCHAR(255),
    GoodForMeal_breakfast VARCHAR(255),
    GoodForMeal_brunch VARCHAR(255),
    CoatCheck VARCHAR(255),
    Smoking VARCHAR(255),
    DriveThru VARCHAR(255),
    DogsAllowed VARCHAR(255),
    BusinessAcceptsBitcoin VARCHAR(255),
    Open24Hours VARCHAR(255),
    BYOBCorkage VARCHAR(255),
    BYOB VARCHAR(255),
    Corkage VARCHAR(255),
    DietaryRestrictions_dairy-free VARCHAR(255),
    DietaryRestrictions_gluten-free VARCHAR(255),
    DietaryRestrictions_vegan VARCHAR(255),
    DietaryRestrictions_kosher VARCHAR(255),
    DietaryRestrictions_halal VARCHAR(255),
    DietaryRestrictions_soy-free VARCHAR(255),
    DietaryRestrictions_vegetarian VARCHAR(255),
    AgesAllowed VARCHAR(255),
    RestaurantsCounterService VARCHAR(255),
    PRIMARY KEY(business_id),
    FOREIGN KEY (business_id) REFERENCES yelp_business(business_id)
};

--==> yelp_business_hours.csv <==
--business_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday
CREATE TABLE yelp_business_hours{
    business_id VARCHAR(255),
    monday VARCHAR(255),
    tuesday VARCHAR(255),
    wednesday VARCHAR(255),
    thursday VARCHAR(255),
    friday VARCHAR(255),
    saturday VARCHAR(255),
    sunday VARCHAR(255),
    PRIMARY KEY(business_id),
    FOREIGN KEY (business_id) REFERENCES yelp_business(business_id)
};

--==> yelp_checkin.csv <==
--business_id,weekday,hour,checkins
CREATE TABLE yelp_checkin{
    business_id VARCHAR(255),
    weekday VARCHAR(255),
    hour VARCHAR(255),
    checkins int(10),
    PRIMARY KEY(business_id)
    FOREIGN KEY (business_id) REFERENCES yelp_business(business_id),
};



--==> yelp_user.csv <==
--"user_id","name","review_count","yelping_since","friends","useful","funny","cool","fans","elite","average_stars","compliment_hot","compliment_more","compliment_profile","compliment_cute","compliment_list","compliment_note","compliment_plain","compliment_cool","compliment_funny","compliment_writer","compliment_photos"
CREATE TABLE yelp_user{
    user_id VARCHAR(255),
    name VARCHAR(255),
    review_count int(10),
    yelping_since VARCHAR(255),
    friends VARCHAR(255),
    useful int(10),
    funny int(10),
    cool int(10),
    fans int(10),
    elite VARCHAR(255),
    average_stars decimal(10.3),
    compliment_hot int(10),
    compliment_more int(10),
    compliment_profile int(10),
    compliment_cute int(10),
    compliment_list int(10),
    compliment_note int(10),
    compliment_plain int(10),
    compliment_cool int(10),
    compliment_funny int(10),
    compliment_writer int(10),
    compliment_photos int(10),
    PRIMARY KEY(user_id)
};

--==> yelp_tip.csv <==
--"text","date","likes","business_id","user_id"
CREATE TABLE yelp_tip{
    text VARCHAR(255),
    date VARCHAR(255),
    likes int(10),
    business_id VARCHAR(255),
    user_id VARCHAR(255),
    PRIMARY KEY(business_id,user_id),
    FOREIGN KEY (business_id) REFERENCES yelp_business(business_id),
    FOREIGN KEY (user_id) REFERENCES yelp_user(user_id)
};

--==> yelp_review2.csv <==
--"review_id","user_id","business_id","stars","date","text","useful","funny","cool"
CREATE TABLE yelp_review2{
    review_id VARCHAR(255),
    user_id VARCHAR(255),
    business_id VARCHAR(255),
    stars int(64),
    date VARCHAR(255),
    text VARCHAR(255),
    useful int(10),
    funny int(10),
    cool int(10),
    PRIMARY KEY(review_id),
    FOREIGN KEY (business_id) REFERENCES yelp_business(business_id),
    FOREIGN KEY (user_id) REFERENCES yelp_user(user_id)   
};

--Schema of Airbnb Data: 
--==> airbnb_listing.csv <==
--id,name,zipcode,host_id,host_is_superhost,host_response_time,host_response_rate,latitude,longitude,host_since,property_type,room_type,neighbourhood,neighbourhood_group_cleansed,accommodates,bathrooms,bedrooms,beds,amenities,price,number_of_reviews,cancellation_policy,picture_url,host_url,review_scores_rating
CREATE TABLE airbnb_listing{
    id decimal(10.3),
    name VARCHAR(255),
    zipcode VARCHAR(255),
    host_id int(10),
    host_is_superhost VARCHAR(255),
    host_response_time VARCHAR(255),
    host_response_rate decimal(10.3),
    latitude decimal(10.8),
    longitude decimal(10.8),
    host_since VARCHAR(255),
    property_type VARCHAR(255),
    room_type VARCHAR(255),
    accommodates int(10),
    bathrooms decimal(10.3),
    bedrooms decimal(10.3),
    beds decimal(10.3),
    amenities VARCHAR(255),
    price decimal(10.3),
    number_of_reviews int(10),
    cancellation_policy VARCHAR(255),
    picture_url VARCHAR(255),
    host_url VARCHAR(255),
    review_scores_rating decimal(10.3),
    PRIMARY KEY(id),
    FOREIGN KEY(zipcode) REFERENCES zipcode(zipcode)
};

--==> reviews_cleaned.csv <==
--listing_id,id,date,reviewer_id,reviewer_name,comments
CREATE TABLE reviews_cleaned{
    listing_id decimal(10.3),
    id int(10),
    date VARCHAR(255),
    reviewer_id decimal(10.8),
    reviewer_name VARCHAR(255),
    comments VARCHAR(255),
    PRIMARY KEY(listing_id),
    FOREIGN KEY(id) REFERENCES airbnb_listing(id)
};

