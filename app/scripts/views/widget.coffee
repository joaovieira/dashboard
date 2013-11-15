'use strict';

class dashboard.Views.WidgetView extends Backbone.View

  tagName: 'li'
  className: 'widget'
  
  template: JST['app/scripts/templates/widget']

  genericEvents:
    'click .delete': 'remove'
    'click .settings': 'popoverSettings'
    
  
  initialize: ->
	  # bind events
    @model.on 'change', @render
    @model.on 'remove', @unrender
    
    @defaultSize = [1,1]


  render: ->
    @$el.html @template widget: @model
    this


  unrender: =>
    @$el.remove()
	  this


  remove: =>
    @model.destroy()
    
    
  popoverSettings: ->
    