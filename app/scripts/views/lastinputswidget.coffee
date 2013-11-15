'use strict';

class dashboard.Views.LastInputsWidgetView extends Backbone.View
  
  tagName: 'li'
  className: 'widget lastinputs-widget'

  template: JST['app/scripts/templates/lastinputswidget']

  events:
    'click tr': 'highlight'
  
  
  initialize: ->
    @events = _.extend({}, @genericEvents, @events);
    @delegateEvents()
    
    @defaultSize = [2,1]
    
    
  render: ->
    @$el.html @template widget: @model, getFavoriteClass: @getFavoriteClass 
    this
    
    
  getFavoriteClass: (fav) ->
    className = "favorite-img clickable"
    className += " selected" if fav
    className
      
      
  highlight: (e) ->
    row = @$(e.currentTarget)
    row.toggleClass('active').siblings().removeClass 'active'