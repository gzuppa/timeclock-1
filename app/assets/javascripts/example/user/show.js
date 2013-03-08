//
//= require backbone/templates/example/user/info

require.config({
    baseUrl: "/assets/backbone/"
});

define([
	"routers/example/user/show",
  "models/example/user/user",
	"views/example/user/info"
], function (Router, User,InfoView) {
	$(function(){
		var user = new User({id: 111, name: "test name"});
		window.models = {};
		window.models.user = user;
		
		var view = new InfoView({model:user});
		$("#main").html(view.$el);

    // Instantiate the router
    window.router = new Router();
    Backbone.history.start();
	});
});