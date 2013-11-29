'use strict';

class dashboard.Views.WidgetView extends Backbone.View

  tagName: 'li'
  className: 'widget'
  
  template: JST['app/scripts/templates/widgets/base']

  events:
    'click tr.input': 'highlight'
    'click .delete': 'remove'
    'click .settings': 'editSettings'
    'click .save': 'saveSettings'
    'click .settings-close': 'viewWidget'
    
  
  initialize: ->
    @className += @model.get 'type'
    
	  # bind events
    @model.on 'change', @render
    @model.on 'remove', @unrender
    
    @defaultSize = [1,1]


  render: =>
    @$el.html @template widget: @model
    if @settingsTemplate?
      @$('.back .widget-content').html @settingsTemplate()
      @$('select').selectpicker()
      @$('.fa-tooltip').tooltip placement: 'bottom'
    this
    
  highlight: (e) ->
    @$(e.currentTarget).toggleClass('active').siblings().removeClass 'active'
    
  editSettings: (e) ->
    @$(e.currentTarget).closest('.widget').toggleClass('flip')
      .children('div').toggleClass('face-hidden')
  
  viewWidget: (e) ->
    @$(e.currentTarget).closest('.widget').removeClass('flip')	
      .children('div').toggleClass('face-hidden')

  unrender: =>
    @$el.remove()
    this
    
  remove: =>
    @model.destroy()
    