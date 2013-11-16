'use strict';

class dashboard.Views.LastInputsWidgetView extends Backbone.View
  
  tagName: 'li'
  className: 'widget lastinputs-widget'

  template: JST['app/scripts/templates/lastinputswidget']
  
  
  initialize: ->
    @events = _.extend({}, @genericEvents, @events);
    @delegateEvents()
    
    @defaultSize = [2,1]
    
    
  render: ->
    @$el.html @template widget: @model
    @model.inputs.each (input) ->
      inputView = new dashboard.Views.InputView model: input
      @$('#inputs').append inputView.render().el
    , this
    this