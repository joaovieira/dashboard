'use strict';

class dashboard.Views.WidgetView extends Backbone.View

  tagName: 'li'
  className: 'widget'
  
  template: JST['app/scripts/templates/widget']

  genericEvents:
    'click tr.input': 'highlight'
    'click .delete': 'remove'
    'click .settings': 'popoverSettings'
    
  
  initialize: ->
    @className += @model.get 'type'
    
	  # bind events
    @model.on 'change', @render
    @model.on 'remove', @unrender
    
    @defaultSize = [1,1]


  render: (inputTemplate) =>
    @$el.html @template widget: @model
    @$('#inputs').append '<div>Loading...</div>'
    this


  unrender: =>
    @$el.remove()
	  this


  remove: =>
    @model.destroy()
    
       
  highlight: (e) ->
    @$(e.currentTarget).toggleClass('active').siblings().removeClass 'active'
    
    
  popoverSettings: ->
    