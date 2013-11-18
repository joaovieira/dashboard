'use strict';

class dashboard.Views.AppView extends Backbone.View

	el: '#dashboard'


	initialize: ->
	  # app default components
	  @menu = new dashboard.Views.NavigationView el: $('#navigation')
	  @widgets = new dashboard.Views.WidgetsView el: $('#widgets')
	  @modal = new dashboard.Views.ModalView el: $('#new-widget-modal')
	  
	  # bind events
	  @listenTo @menu, 'alert', @showAlert
	  @listenTo @menu, 'new', @showModal
	  @listenTo @widgets, 'new', @showModal
	  
	  
	home: ->  
	  @$('#alert').show()
	  
	  
	showAlert: (message) =>
	  alert = new dashboard.Views.AlertView(message)
	  @$('#alert').html(alert.render().el).show()
	
	
	addWidgetModal: (category = null, widget = null) ->
	  @modal.prepare category, widget
	  @modal.show()