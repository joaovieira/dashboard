###
Define the dashboard object, including the init method and Backbone components.
###
window.dashboard =
	Models: {}
	Collections: {}
	Views: {}
	Routers: {}

	###
	Init the application by initializing the composite app view and
	the router with pushState.
	###
	init: ->
		'use strict'
		
		# init app view
		@appView = new this.Views.AppView()
		
		# init router
		@router = new this.Routers.AppRouter()
		Backbone.history.start {pushState: true, root: '/'}


###
Start application once the document is ready.
###
$ ->
	'use strict'
	dashboard.init()
