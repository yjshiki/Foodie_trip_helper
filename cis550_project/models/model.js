var mongoose = require('mongoose');
var connect = require('./connect');

mongoose.connect(connect, {useNewUrlParser: true});

module.exports = {
	restaurant: mongoose.model('yelpModel', {
		name: {
			type: String,
			required: true
		},
		phone : {
			type: String,
			required: true
		},
		price : {
			type: String,
			required: true
		},
		rating: {
			type: String,
			required: true
		},
		review_count: {
			type: String,
			required: true
		}
	})
};
