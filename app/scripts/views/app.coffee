'use strict';

###
Main dashboard view. It is a composite view that delegates control to navigation,
widget and alert sub views.
###
class dashboard.Views.AppView extends Backbone.View

	el: '#dashboard'


	###
	Init sub views.
	###
	initialize: ->
	  @menu = new dashboard.Views.NavigationView el: $('#navigation')
	  @widgets = new dashboard.Views.WidgetsView el: $('#widgets')
	  @modal = new dashboard.Views.ModalView el: $('#new-widget-modal')
	  
	  # bind events
	  @listenTo @menu, 'alert', @showAlert
	  
	  
	###
	Show default dashboard view by removing the alert, if it visible.
	###
	home: ->  
	  @$('#alert').hide()
	  
	  
	###
	Show alert by creating the alert view and rendering in the right element.
	###
	showAlert: (message) =>
	  alert = new dashboard.Views.AlertView(message)
	  @$('#alert').html(alert.render().el).show()


	###
	Prepare and show modal screen to choose widget on the passed navigation level.
	###
	addWidgetModal: (category = null, widget = null) ->
 		@modal.show category, widget