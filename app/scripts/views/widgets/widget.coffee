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
      @$('.back').hide().find('.widget-content').html @settingsTemplate()
      @$('select').selectpicker()
      @$('.fa-tooltip').tooltip placement: 'bottom'
    this
    
    
  highlight: (e) ->
    @$(e.currentTarget).toggleClass('active').siblings().removeClass 'active'
    
    
  editSettings: (e) =>
    widget = @$(e.currentTarget).closest '.widget'
    transitionEnd = 'transitionend webkitTransitionEnd oTransitionEnd otransitionend'

    # toggle flip and hide back when transition is over
    widget.find('.back').show 50, ->
      widget.toggleClass('flip').on transitionEnd, ->
        $(this).off transitionEnd
        widget.find('.front').hide()
  
  
  viewWidget: (e) =>
    widget = @$(e.currentTarget).closest '.widget'
    transitionEnd = 'transitionend webkitTransitionEnd oTransitionEnd otransitionend'
    
    # toggle flip and hide back when transition is over
    widget.find('.front').show 50, =>
      widget.removeClass('flip').on transitionEnd, ->
        $(this).off transitionEnd
        widget.find('.back').hide()


  unrender: =>
    @$el.remove()
    this
    
    
  remove: =>
    @model.destroy()
    