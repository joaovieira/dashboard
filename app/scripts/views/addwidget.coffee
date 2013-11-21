'use strict';

class dashboard.Views.AddWidgetView extends Backbone.View

  tagName: 'li'
  className: 'widget add'

  template: JST['app/scripts/templates/addwidget']
  
  
  genericEvents:
    'click .widget-content': 'newWidget'
    

  initialize: ->
    @events = _.extend({}, @genericEvents, @events)
    @delegateEvents()
    
    @defaultSize = [1,1]
    @maxSize = [1,1]
    

  render: ->
    @$el.html @template widget: @model
    this
    
    
  newWidget: ->
    dashboard.router.navigate 'new', { trigger: true }