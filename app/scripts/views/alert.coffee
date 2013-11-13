'use strict';

class dashboard.Views.AlertView extends Backbone.View

  className: "alert alert-danger alert-dismissable fade in"

  template: JST['app/scripts/templates/alert']
    
  initialize: (options = {}) ->
    @message = options
    
  render: ->
    @$el.html @template message: @message
    this
