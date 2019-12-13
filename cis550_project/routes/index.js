var express = require('express');
var router = express.Router();
var path = require('path');
var config = require('../db-config.js');

/* ----- Connects to MongoDB database ----- */
// var mongoose = require('mongoose');
// mongoose.connect('mongodb://127.0.0.1:27017/yelp', {useNewUrlParser: true});

// var mongoose = require('mongoose');
// var models = require('../models/models');

var MongoClient = require('mongodb').MongoClient;
var url = "mongodb://127.0.0.1:27017/";

// const client = new MongoClient(uri, { useNewUrlParser: true });


/* ----- Connects to your mySQL database ----- */

var mysql = require('mysql');

config.connectionLimit = 10;
var connection = mysql.createPool(config);


/* ------------------------------------------- */
/* ----- Routers to handle FILE requests ----- */
/* ------------------------------------------- */

router.get('/', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'WelcomeAuthen.html'));
});

router.get('/navigation', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'Navigation.html'));
});
router.get('/tophouse', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'TopHouse.html'));
});
router.get('/houseDetails', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'houseDetails.html'));
});
router.get('/housereviews', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'houseReviews.html'));
});
router.get('/findrestaurants', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'findRestaurants.html'));
});
router.get('/popularCategories', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'popularCategories.html'));
});
router.get('/yelptrustedreviews', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'yelpTrustedReviews.html'));
});
router.get('/moreBusiness', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'moreBusiness.html'));
});
router.get('/resources', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'resources.html'));
});
router.get('/reference', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'reference.html'));
});
router.get('/aboutUs', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', 'aboutUs.html'));
});
/* Template for a FILE request router:

Specifies that when the app recieves a GET request at <PATH>,
it should respond by sending file <MY_FILE>

router.get('<PATH>', function(req, res) {
  res.sendFile(path.join(__dirname, '../', 'views', '<MY_FILE>'));
});

*/


/* ------------------------------------------------ */
/* ----- Routers to handle data requests ----- */
/* ------------------------------------------------ */


/* find neighborhood with the most stays that match input criteria */
router.post('/findNeighborhood/', function(req, res) {
  var type = req.body.roomType;
  var maxprice = req.body.maxPrice;
  var query =  `select
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
order by num_houses desc;`;

connection.query(query, function (err, rows, fields) {
  if (err) console.log(err);
  else {
    console.log(rows);
    res.json(rows);
  }
});
});

/* detailed house search with restricting conditions */
router.post('/houseDetails/', function(req, res) {
  var type = req.body.roomType;
  var cancellation = req.body.cancellationPolicy;
  var minprice = req.body.minPrice;
  var maxprice = req.body.maxPrice;
  var zip = req.body.zipCode;
  // Parses the customParameter from the path, and assigns it to variable myData
  //var zipCode = req.params.houseDetails;
  var query =  `select host_response_time, CAST(host_response_rate AS CHAR(50)) AS host_response_rate, bathrooms, bedrooms, price, picture_url
                from airbnb_listing
                where airbnb_listing.zipcode= '${zip}'
                and airbnb_listing.cancellation_policy= '${cancellation}'
                and airbnb_listing.room_type= '${type}'
                and airbnb_listing.price > '${minprice}'
                and airbnb_listing.price < '${maxprice}'
                order by price
                limit 10;`;

connection.query(query, function (err, rows, fields) {
  if (err) console.log(err);
  else {
    console.log(rows);
    res.json(rows);
  }
});
});
//
//
// router.get('/houseDetails/:houseDetails', function(req, res) {
//   // Parses the customParameter from the path, and assigns it to variable myData
//   var zipCode = req.params.houseDetails;
//   var query = `select property_type, bathrooms, bedrooms, price, picture_url
//                 from airbnb_listing
//                 where airbnb_listing.zipcode='${zipCode}'
//                 and price > 65
//                 and price < 200
//                 order by price
//                 limit 10; `;
//
//   connection.query(query, function(err, rows, fields) {
//     if (err) console.log(err);
//     else {
//       // Returns the result of the query (rows) in JSON as the response
//       res.json(rows);
//     }
//   });
// });

/* intersting reviews for houses in the given neighborhood */
router.get('/neiReviews/:neighborhoodReview', function(req, res) {
  // Parses the customParameter from the path, and assigns it to variable myData
  var myNeighborhood1 = req.params.neighborhoodReview;
  var query = `
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
  order by num_neighborhoods desc
  limit 200
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
  where t.neighborhood = '${myNeighborhood1}'
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
);`;

  connection.query(query, function (err, rows, fields) {
    if (err) console.log(err);
    else {
      console.log(rows);
      res.json(rows);
    }
  });
});


/* ----- find restaurants ----- */
router.post('/selectedRestaurants/', function(req, res) {
  var maxprice = req.body.maxPrice;
  var zipcode = req.body.zipCode;

  MongoClient.connect(url, {useNewUrlParser: true }, function(err, db) {
      if (err) throw err;
      var dbo = db.db("yelp");
      var mquery = {'zip_code': Number(zipcode), 'review_count': {$gte: 10}, 'price': {$lte: maxprice}};
      var output = {projection: {_id:0, name:1, phone:1, price: 1, rating:1, review_count:1}};
      dbo.collection("nyc"). find(mquery, output).sort({rating:-1, review_count:-1}).limit(5).toArray(function(err, result) {
          if (err) throw err;
          console.log(result);
          // db.close();
          res.json(result);
      });
  });
});


/* ----- popuar categories ----- */
router.get('/categories/:category', function(req, res) {
  var query =`SELECT TRIM(TRAILING '\r' FROM category) AS category
  FROM yelp_categories 
  GROUP BY TRIM(TRAILING '\r' FROM category)
  ORDER BY COUNT(business_id) DESC
  LIMIT 10;`
;

  connection.query(query, function(err, rows, fields) {
    if (err) console.log(err);
    else {
      console.log(rows);
      res.json(rows);
    }
  });
});

router.get('/businesses/:c', function(req, res) {
  var selected_category =  req.params.c;
  var query = `SELECT y1.name, y1.stars, y1.review_count
FROM yelp_business y1
JOIN yelp_categories y2
ON y1.business_id = y2.business_id
WHERE TRIM(TRAILING '\r' FROM y2.category) = '${selected_category}'
ORDER BY y1.review_count DESC, y1.stars DESC
LIMIT 5;`;
  connection.query(query, function (err, rows, fields) {
    if (err) console.log(err);
    else {
      console.log(rows);
      res.json(rows);
    }
  });
});

/* Trusted Yelp Reviews */
router.get('/yelpReviews/:yelpReview', function(req, res) {
  // Parses the customParameter from the path, and assigns it to variable myData
  var myBusiness = req.params.yelpReview;
  var query =
  `select
	a.user_id as user_id,
	a.name as user_name,
	b.review_date as review_date,
	b.review as review
from (
	select
		a.user_id as user_id,
		a.name as name
	from yelp_user a
	where
		a.yelping_since <= 2017
		or 0.2 * a.review_count >= all(
			select t.review_count_business
			from (
				select
					x.business_id as business_id,
					count(x.review_id) as review_count_business
				from yelp_review2 x
				where x.user_id = user_id
				group by business_id
			) t
		)
		or (
			select count(*)
			from yelp_review2 x
			where x.user_id = user_id
			and x.useful = 1
		) >= 2
		or 2 >= all(
			select t.review_count_business
			from (
				select
					x.business_id as business_id,
					extract(year from x.date) as year,
					count(x.review_id) as review_count_business
				from yelp_review2 x
				where x.user_id = user_id
				group by business_id, year
			) t
		)
) a
join (
	select
		b.user_id as user_id,
		c.business_id as business_id,
		b.text as review,
		b.date as review_date,
		c.name as buiness_name
	from yelp_review2 b
	join yelp_business c
	on b.business_id = c.business_id
) b
on a.user_id = b.user_id
where b.buiness_name = '${myBusiness}'
order by review_date desc
limit 10;`;


  connection.query(query, function (err, rows, fields) {
    if (err) console.log(err);
    else {
      console.log(rows);
      res.json(rows);
    }
  });
});


/* business filter */

router.get('/morebuss/:moreBusinessName', function(req, res) {
  // Parses the customParameter from the path, and assigns it to variable myData
  var myBusinesses = req.params.moreBusinessName;
  var query =
  `select distinct
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
  limit 3;`;

  connection.query(query, function (err, rows, fields) {
    if (err) console.log(err);
    else {
      console.log(rows);
      res.json(rows);
    }
  });
});


/* General Template for GET requests:

router.get('/routeName/:customParameter', function(req, res) {
  // Parses the customParameter from the path, and assigns it to variable myData
  var myData = req.params.customParameter;
  var query = '';
  console.log(query);
  connection.query(query, function(err, rows, fields) {
    if (err) console.log(err);
    else {
      // Returns the result of the query (rows) in JSON as the response
      res.json(rows);
    }
  });
});
*/


module.exports = router;
