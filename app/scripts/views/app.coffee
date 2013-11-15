'use strict';

class dashboard.Views.AppView extends Backbone.View

	el: '#dashboard'


	initialize: ->
	  # app default components
	  @menu = new dashboard.Views.NavigationView el: $('#navigation')
	  @widgets = new dashboard.Views.WidgetsView el: $('#widgets')
	  
	  # bind events
	  @listenTo @menu, 'alert', @showAlert
	  @listenTo @widgets, 'newWidget', @showModal
	  
	  
	showAlert: (message) =>
	  @$('#alert').html new dashboard.Views.AlertView(message).render().el
	
	
	showModal: ->