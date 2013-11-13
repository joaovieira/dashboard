'use strict';

class dashboard.Views.AppView extends Backbone.View

	el: '#dashboard'

	initialize: ->
	  @menu = new dashboard.Views.NavigationView el: $('#navigation')
	  @widgets = new dashboard.Views.WidgetsView el: $('#widgets')
	  
	  @menu.bind 'alert', @showAlert
	  
	showAlert: (message) =>
	  @$('#alert').html new dashboard.Views.AlertView(message).render().el
	  
	  ###
	  new dashboard.Collections.WidgetCollection().fetch

      success: (collection) ->
        view = new dashboard.Views.WidgetsView collection: collection
        $('#widget-container').html view.render().el

      error: (collection, response) -> editor.log "Sad face! Server says #{response.status}."
    ###