window.dashboard =
	Models: {}
	Collections: {}
	Views: {}
	Routers: {}
	init: ->
		'use strict'
		# init routes
		
		@app = new this.Views.AppView()

$ ->
	'use strict'
	dashboard.init();
	Backbone.history.start();
