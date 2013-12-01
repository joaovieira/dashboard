'use strict';

class dashboard.Views.WidgetsView extends Backbone.View

  initialize: ->
    @collection = new dashboard.Collections.Widgets []

    # init gridster
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
        
   
    @gridster = @$('ul').gridster(options).data('gridster')

    # bind events
    @collection.on 'add', @addWidget
    @collection.on 'remove', @removeWidget

    # init widgets
    @collection.fetch()
    @addAddWidget()
    
  
  addWidget: (widget) =>
    newWidget = @getView widget
    
    # get addWidget if any
    addWidget = @gridster.$widgets.filter('.add')
    
    if addWidget.length is 1  
  	  # replace addWidget with new one and add addWidget again
  	  @overrideAddWidget addWidget, newWidget
  	  @addAddWidget()
    else
      size = newWidget.model.get 'size'
      position = newWidget.model.get 'position'
      
      @gridster.add_widget newWidget.render().el, size[0], size[1], 
        position?.col ? null, position?.row ? null, newWidget.maxSize ?= []

    @showLast()

  
  removeWidget: (widget) =>
    toRemove = @gridster.$widgets.filter("##{widget.cid}")
    @gridster.remove_widget toRemove, @showLast
    @


  createWidget: (modalData) ->
    @collection.create modalData
    
    
  overrideAddWidget: (oldW, newW) ->
  	col = oldW.data 'col'
  	row = oldW.data 'row'
  	size = newW.model.get 'size'
  	
  	addModel = @collection.findWhere type: 'add'
  	@collection.remove addModel
  	@gridster.add_widget newW.render().el, size[0], size[1], col, row, newW.maxSize ?= []
    

  addAddWidget: ->
  	@collection.add new dashboard.Models.AddWidget()
  	
  
  getWidget: (type) ->
    @collection.findWhere type: type  	
  
  
  getView: (model) ->
    switch model.get 'type'
      when 'last-inputs' then new dashboard.Views.LastInputsWidgetView model: model
      when 'favorites' then new dashboard.Views.FavoritesWidgetView model: model
      when 'links-occupation' then new dashboard.Views.LinksOccupationWidgetView model: model
      when 'add' then new dashboard.Views.AddWidgetView model: model
      else new dashboard.Views.WidgetView model: model
        
        
  showLast: (e) =>
    @$el.fadeIn() if @gridster.$widgets.length is @collection.length
    
    
  addFavorite: (input) ->
    if favoriteWidget = @getWidget 'favorites'
      favoriteWidget.inputs.add input
    
  
  removeFavorite: (input) ->
    if favoriteWidget = @getWidget 'favorites'
      favoriteWidget.inputs.remove input
      
      
  saveSize: (e, ui, widget) =>
    size = [widget.data('sizex'), widget.data('sizey')]
    id = widget.attr 'id'
    widget = @collection.get id
    widget.set 'size', size
    widget.save()
    
    
  savePosition: (e, ui) =>
    widget = ui.$player
    position = 
      col: widget.data 'col'
      row: widget.data 'row'
    id = widget.attr 'id'
    widget = @collection.get id
    widget.set 'position', position
    widget.save()