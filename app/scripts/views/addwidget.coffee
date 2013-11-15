'use strict';

class dashboard.Views.AddWidgetView extends Backbone.View

  tagName: 'li'
  className: 'widget add-widget'

  template: JST['app/scripts/templates/addwidget']

  initialize: ->
    @events = _.extend({}, @genericEvents, @events)
    @delegateEvents()
    
    @defaultSize = [1,1]
    @maxSize = [1,1]
    

  render: ->
    @$el.html @template widget: @model
    this