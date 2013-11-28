'use strict';

class dashboard.Views.WidgetView extends Backbone.View

  tagName: 'li'
  className: 'widget'
  
  template: JST['app/scripts/templates/widget']

  events:
    'click tr.input': 'highlight'
    'click .delete': 'remove'
    'click .settings': 'editSettings'
    'click .back': 'saveSettings'
    
  
  initialize: ->
    @className += @model.get 'type'
    
	  # bind events
    @model.on 'change', @render
    @model.on 'remove', @unrender
    
    @defaultSize = [1,1]


  render: =>
    @$el.html @template widget: @model
    this
    
  highlight: (e) ->
    @$(e.currentTarget).toggleClass('active').siblings().removeClass 'active'
    
  editSettings: (e) ->
    @$(e.currentTarget).closest('.widget').toggleClass 'flip'
  
  saveSettings: (e) ->
    @$(e.currentTarget).closest('.widget').removeClass 'flip'

  unrender: =>
    @$el.remove()
    this
    
  remove: =>
    @model.destroy()
    