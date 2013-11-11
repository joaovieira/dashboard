window.dashboard =
	Models: {}
	Collections: {}
	Views: {}
	Routers: {}
	init: ->
		'use strict'
		console.log 'Hello from Backbone!'
		new this.Views.AppView()

$ ->
	'use strict'
	dashboard.init();
	Backbone.history.start();
