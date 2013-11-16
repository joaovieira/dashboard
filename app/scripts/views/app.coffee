'use strict';

class dashboard.Views.AppView extends Backbone.View

	el: '#dashboard'


	initialize: ->
	  # app default components
	  @menu = new dashboard.Views.NavigationView el: $('#navigation')
	  @widgets = new dashboard.Views.WidgetsView el: $('#widgets')
	  
	  # bind events
	  @listenTo @menu, 'alert', @showAlert
	  
	  
	home: ->  
	  @$('#alert').show()
	  
	  
	showAlert: (message) =>
	  alert = new dashboard.Views.AlertView(message)
	  @$('#alert').html(alert.render().el).show()
	
	
	showModal: ->
	  modal = new dashboard.Views.NewWidgetModalView()
	  @$('#new-widget-modal').html(modal.render().el)