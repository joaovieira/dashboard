'use strict';

###
Backbone View managing the alert notification.
###
class dashboard.Views.AlertView extends Backbone.View

  className: "alert alert-dismissable fade in"

  template: JST['app/scripts/templates/alert']
  

  ###
  Init the view with the message data received (message text and type).
  ###  
  initialize: (options = {}) ->
    @message = options

    # set bootstrap alert style given by the message type
    @$el.addClass " alert-#{@message.type}" 
    @
    

  ###
  Render the template with the message data.
  ###
  render: ->
    @$el.html @template message: @message
    this