'use strict';

class dashboard.Views.NewWidgetModalView extends Backbone.View

  className: "modal fade"
  template: JST['app/scripts/templates/newwidgetmodal']
  
  initialize: ->
    @$el.on 'hidden.bs.modal', @returnHome
  
  render: ->
    @$el.html @template
    @$el.modal()
    this  
    
  returnHome: ->
    dashboard.router.navigate ''
