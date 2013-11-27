'use strict';

class dashboard.Views.AlertView extends Backbone.View

  className: "alert alert-dismissable fade in"

  template: JST['app/scripts/templates/alert']
    
  initialize: (options = {}) ->
    @message = options
    @$el.addClass " alert-#{@message.type}" 
    @
    
  render: ->
    @$el.html @template message: @message
    this
