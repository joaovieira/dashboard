'use strict';

###
Backbone Collection View that manages the set of widgets views using the Gridster.js
jQuery library. This view is the direct connection between the widget collection and the
gridster object.
###
class dashboard.Views.WidgetsView extends Backbone.View

  ###
  Initialize the view by initializing the gridster object, setting the add and remove widget events
  to the grid and fetching the current locally stored list of widgets from the collection.
  ###
  initialize: ->
    @collection = new dashboard.Collections.Widgets []

    # gridster parameters
    options =
      widget_margins: [15, 15],
      widget_base_dimensions: [@$el.data('column-size'), @$el.data('column-size')]
      max_cols: @$el.data 'columns'
      min_rows: 2
      draggable:
        handle: 'handle'
        stop: @savePosition
      resize:
        enabled: true
        handle_append_to: '.back'
        max_size: [2, 2]
        stop: @saveSize
        
    # init gridster object
    @gridster = @$('ul').gridster(options).data('gridster')

    # bind events
    @collection.on 'add', @addWidget
    @collection.on 'remove', @removeWidget

    # init widgets
    @collection.fetch { success: => @resetFavorites() }

    @addAddWidget()
    
  
  ###
  Add widget to the screen. In order for the Add widget to be the last, it is removed,
  the new one is positioned in its place and then inserted again into the gridster object.
  This method runs when a widget is added to the collection, be it while loading all from
  the local storage or simply adding a new one from the modal screen.
  ###
  addWidget: (widget) =>
    # create widget view
    newWidget = @getView widget
    
    # get addWidget if any
    addWidget = @gridster.$widgets.filter('.add')
    
    if addWidget.length is 1  
  	  # replace addWidget with new one and add addWidget again
  	  @overrideAddWidget addWidget, newWidget
  	  @addAddWidget()
    else
      # set widget in its previously save position (when loading from local storage)
      size = newWidget.model.get 'size'
      position = newWidget.model.get 'position'

      col = if size[0] > @gridster.cols then @gridster.cols else size[0]
      
      # add widget in previous position or in the default
      @gridster.add_widget newWidget.render().el, col, size[1], 
        position?.col ? null, position?.row ? null, newWidget.maxSize ?= []

    # fade in widgets once last (the add widget) is added
    @showLast()

  
  ###
  Find widget block element to remove in gridster object by its ID attribute.
  ###
  removeWidget: (widget) =>
    toRemove = @gridster.$widgets.filter "##{widget.cid}"
    @gridster.remove_widget toRemove, @showLast
    @


  ###
  Add widget to the collection, which subsequently adds it to the screen.
  ###
  createWidget: (modalData) ->
    @collection.create modalData
    
  
  ###
  Override one widget with the other in its old position.
  ###  
  overrideAddWidget: (oldW, newW) ->
  	col = oldW.data 'col'
  	row = oldW.data 'row'
  	size = newW.model.get 'size'

    # remove widget from collection -> it will be removed from screen
  	addModel = @collection.findWhere type: 'add'
  	@collection.remove addModel

    # add new widget in same position
  	@gridster.add_widget newW.render().el, size[0], size[1], col, row, newW.maxSize ?= []
    

  ###
  Add Add widget without creating it in the collection (not saving to local storage)
  ###
  addAddWidget: ->
  	@collection.add new dashboard.Models.AddWidget()
  	
  
  ###
  Find widget in collection by type.
  ###
  getWidget: (type) ->
    @collection.findWhere type: type  	
  
  
  ###
  Return widget view depending on the data type.
  ###
  getView: (model) ->
    switch model.get 'type'
      when 'last-inputs' then new dashboard.Views.LastInputsWidgetView model: model
      when 'favorites' then new dashboard.Views.FavoritesWidgetView model: model
      when 'links-occupation' then new dashboard.Views.LinksOccupationWidgetView model: model
      when 'low-priority' then new dashboard.Views.LowPriorityWidgetView model: model
      when 'stats' then new dashboard.Views.StatsWidgetView model: model
      when 'add' then new dashboard.Views.AddWidgetView model: model
      else new dashboard.Views.WidgetView model: model
        
  
  ###
  Fade in this view when all widgets are visible the gridster object.
  ###      
  showLast: (e) =>
    @$el.fadeIn() if @gridster.$widgets.length is @collection.length
    
  
  ###
  Add favorite input to favorites widget, when one favorites it in another widget 
  (eg. Last Inputs). This method is called directly from the widget that favorites.
  ###  
  addFavorite: (input) ->
    if favoriteWidget = @getWidget 'favorites'
      favoriteWidget.inputs.add input
    
  
  ###
  Opposite opperation as above. Remove favorite input from favorites widget.
  ###
  removeFavorite: (input) ->
    if favoriteWidget = @getWidget 'favorites'
      favoriteWidget.inputs.remove input
      
  
  ###
  Save the new size of the resized widget.
  ###    
  saveSize: (e, ui, widget) =>
    # new size
    size = [parseInt(widget.attr('data-sizex')), parseInt(widget.attr('data-sizey'))]
    
    # update model
    id = widget.attr 'id'
    widgetModel = @collection.get id
    widgetModel.set 'size', size
    widgetModel.save()

    # trigger resize event to possibly redraw data on the widget (eg. graphs)
    widgetModel.resize()
    

  ###
  Save the new position of the repositioned widget.
  ###
  savePosition: (e, ui) =>
    # new position
    widget = ui.$player
    position = 
      col: parseInt widget.attr 'data-col'
      row: parseInt widget.attr 'data-row'

    # update model
    id = widget.attr 'id'
    widgetModel = @collection.get id
    widgetModel.set 'position', position
    widgetModel.save()


  ###
  Reset favorite inputs in the Favorites widget based on the favorited
  inputs from the Last Inputs, if both are available.
  ###
  resetFavorites: ->
    # Check if both widgets are available
    if lastInputsWidget = @collection.findWhere {type: 'last-inputs'}
      if favoritesWidget = @collection.findWhere {type: 'favorites'}
        
        # add input reference to favorites for each favorite in last inputs
        favorites = lastInputsWidget.inputs.where favorite: true
        favoritesWidget.inputs.add input for input in favorites