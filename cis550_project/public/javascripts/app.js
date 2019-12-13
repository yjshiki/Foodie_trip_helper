var app = angular.module('angularjsNodejsTutorial', []);

app.controller('findNeighborhoodController', function($scope, $http) {
  $scope.roomTypeRange = ['Private room', 'Entire home/apt', 'Shared room', 'Hotel room'];
  $scope.submit = function() {
    var request = $http({
    url: '/findNeighborhood/',
    method: "POST",
    data: {
      'roomType': $scope.roomType,
      'maxPrice': $scope.maxPrice
    }
  }).then(res => {
    console.log(res.data);
    $scope.findNeighborhood = res.data;
  }, err => {
    console.log("ERROR: ", err);
  });
  }
});



app.controller('houseDetailsController', function($scope, $http) {
  $scope.roomTypeRange = ['Private room', 'Entire home/apt', 'Shared room', 'Hotel room'];
  $scope.cancellationPolicyRange = ['strict_14_with_grace_period', 'moderate', 'flexible', 'strict','super_strict_30','super_strict_60'];
  $scope.submit = function() {
    var request = $http({
    url: '/houseDetails/',
    method: "POST",
    data: {
      'roomType': $scope.roomType,
      'cancellationPolicy': $scope.cancellationPolicy,
      'minPrice': $scope.minPrice,
      'maxPrice': $scope.maxPrice,
      'zipCode': $scope.zipCode
    }
  }).then(res => {
    console.log(res.data);
    $scope.houseDetails = res.data;
  }, err => {
    console.log("ERROR: ", err);
  });
  }
});

app.controller('houseReviewsController', function($scope, $http) {
  $scope.submitNeighborhood = function() {
    $http({
    url: '/neiReviews/' + $scope.neighborhoodReview,
    method: 'GET'
  }).then(res => {
    console.log("neiborReviews: ", res.data);
    $scope.neiborReviews = res.data;
  }, err => {
    console.log("ERROR: ", err);
  });
  }
});


app.controller('findRestaurantsController', function($scope, $http) {
  $scope.priceRange = [1, 2, 3, 4, 5];
  $scope.submit = function() {
    var request = $http({
    url: '/selectedRestaurants/',
    method: "POST",
    data: {
      'maxPrice': $scope.maxPrice,
      'zipCode': $scope.zipCode
    }
  }).then(res => {
    console.log(res.data);
    $scope.selectedRestaurants = res.data;
  }, err => {
    console.log("ERROR: ", err);
  });
  }
});

app.controller('popularCategoriesController', function($scope, $http) {
  // TODO: Q1
  $http({
    url: '/categories/:category',
    method: 'GET'
  }).then(res => {
    console.log("categories: ", res.data);
    $scope.categories= res.data;
  }, err => {
    console.log("Categories ERROR: ", err);
  });

   $scope.showCategories = function(c) {
     $http({
     url: '/businesses/' + c.category,
     method: 'GET'
   }).then(res => {
     console.log("business: ", res.data);
     $scope.businesses= res.data;
   }, err => {
     console.log("business ERROR: ", err);
   });
 }

});

app.controller('yelpReviewsController', function($scope, $http) {
  $scope.submitBusiness = function() {
    $http({
    url: '/yelpReviews/' + $scope.yelpReview,
    method: 'GET'
  }).then(res => {
    console.log("yelpReviews: ", res.data);
    $scope.yelpBusinessReviews = res.data;
  }, err => {
    console.log("ERROR: ", err);
  });
  }
});

app.controller('moreBusinessController', function($scope, $http) {
  $scope.submitBusinesses = function() {
    $http({
    url: '/morebuss/' + $scope.moreBusinessName,
    method: 'GET'
  }).then(res => {
    console.log("moreBusiness: ", res.data);
    $scope.moreBusinesses = res.data;
  }, err => {
    console.log("ERROR: ", err);
  });
  }
});
