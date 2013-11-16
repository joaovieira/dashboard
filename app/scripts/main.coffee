window.dashboard =
	Models: {}
	Collections: {}
	Views: {}
	Routers: {}
	init: ->
		'use strict'
		
		# init app view
		@appView = new this.Views.AppView()
		
		# init routes
		@router = new this.Routers.AppRouter()
		Backbone.history.start();

$ ->
	'use strict'
	dashboard.init();
