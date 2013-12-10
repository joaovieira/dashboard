'use strict';

class dashboard.Views.WidgetView extends Backbone.View

  tagName: 'li'
  className: 'widget'
  
  template: JST['app/scripts/templates/widgets/base']

  events:
    'click tr.input': 'highlight'
    'click .widget-remove': 'remove'
    'click .settings': 'editSettings'
    'click .settings-save': 'saveSettings'
    'click .settings-close': 'viewWidget'
    
  
  initialize: ->
    @$el.attr 'id', @model.cid
    
    # bind model events
    @model.on 'update', @refresh

    @model.refresh()


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
    @$(e.currentTarget).closest('.widget').toggleClass 'flip'
  
  
  viewWidget: (e) ->
    @$(e.currentTarget).closest('.widget').removeClass 'flip'


  unrender: =>
    @$el.remove()
    this
    
    
  remove: =>
    @model.destroy()
    