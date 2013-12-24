'use strict';

###
Backbone View for the base widget layout inside the Gridster grid block. This base
view is responsible for drawing everything in the widget except the content below the title
and the settings inputs in the back of the widget.
###
class dashboard.Views.WidgetView extends Backbone.View

  tagName: 'li'
  className: 'widget'
  
  template: JST['app/scripts/templates/widgets/base']


  ###
  Widget-only events for removing the widget, flipping, saving and highlighting.
  ###
  events:
    'click tr.input': 'highlight'
    'click .widget-remove': 'remove'
    'click .settings': 'editSettings'
    'click .settings-save': 'saveSettings'
    'click .settings-close': 'viewWidget'
    
  
  ###
  Set the HTML element attribute id as the id of the view's inner model.
  Refresh (redraw) widget once the model is updated.
  ###
  initialize: ->
    @$el.attr 'id', @model.cid
    
    # bind model events
    @model.on 'update', @refresh

    @model.refresh()


  ###
  Render widget for the first time, before loading the data and refreshing.
  ###
  render: =>
    @$el.html @template widget: @model

    # draw the settings inputs in the back panel, if widget supports it
    if @settingsTemplate?
      @$('.back').hide().find('.widget-content .wrapper').html @settingsTemplate()
      @$('select').selectpicker()
      @$('.fa-tooltip').tooltip placement: 'bottom'

    this
    
   
  ###
  Highlight row once it is selected.
  ### 
  highlight: (e) ->
    @$(e.currentTarget).toggleClass('active').siblings().removeClass 'active'
    
   
  ###
  Flip widget with CSS by toggling the flip class. Once the flip is finished,
  hide the back part. This allows moving and resizing to be lighter and more responsible.
  ###  
  editSettings: (e) =>
    widget = @$(e.currentTarget).closest '.widget'
    transitionEnd = 'transitionend webkitTransitionEnd oTransitionEnd otransitionend'

    # show the back part before starting flip animation
    widget.find('.back').show 50, ->
      # toggle flip and hide back when transition is over
      widget.toggleClass('flip').on transitionEnd, ->
        # detach this handler to prevent more than one run (for another of the specified events)
        $(this).off transitionEnd
        widget.find('.front').hide()
  
  
  ###
  The opposite of showing the settings, flipping the other way around by removing
  the flip class.
  ###
  viewWidget: (e) =>
    widget = @$(e.currentTarget).closest '.widget'
    transitionEnd = 'transitionend webkitTransitionEnd oTransitionEnd otransitionend'
    
    # show the back part before starting flip animation
    widget.find('.front').show 50, =>
      # toggle flip and hide back when transition is over
      widget.removeClass('flip').on transitionEnd, ->
        # detach this handler to prevent more than one run (for another of the specified events)
        $(this).off transitionEnd
        widget.find('.back').hide()

  
  ###
  Remove widget by destroying its model. This will trigger an event on the Widgets collection that
  removes the widget block from the gridster in the collections view.
  ###  
  remove: =>
    @model.destroy()