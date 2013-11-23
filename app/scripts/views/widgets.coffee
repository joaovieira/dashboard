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
      resize:
        enabled: true,
        max_size: [2, 2]
   
    @gridster = @$('ul').gridster(options).data('gridster')

    # bind events
    @collection.on 'add', @addWidget
    @collection.on 'remove', @removeWidget

    # init widgets
    @addAddWidget()
    #@collection.fetch()
    
  
  addWidget: (widget) =>
    newWidget = @getView widget
    
    # get addWidget if any
    addWidget = @gridster.$widgets.filter('.add')
    
    if addWidget.length is 1  
  	  # replace addWidget with new one and add addWidget again
  	  @overrideAddWidget addWidget, newWidget
  	  @addAddWidget()
    else
  	  @gridster.add_widget newWidget.render().el, newWidget.defaultSize[0], newWidget.defaultSize[1],
  	   null, null, newWidget.maxSize ?= []

    @showLast()

  
  removeWidget: (widget) =>
    toRemove = @gridster.$widgets.filter(".#{widget.get 'type'}")
    @gridster.remove_widget toRemove, @showLast


  createWidget: (modalData) ->
    @collection.add modalData
    
    
  overrideAddWidget: (oldW, newW) ->
  	col = oldW.data 'col'
  	row = oldW.data 'row'
  	
  	addModel = @collection.findWhere type: 'add'
  	@collection.remove addModel
  	@gridster.add_widget newW.render().el, newW.defaultSize[0], newW.defaultSize[1], col, row, newW.maxSize ?= []
    

  addAddWidget: ->
  	@collection.add new dashboard.Models.AddWidget()
  	
  
  getView: (model) ->
    switch model.get 'type'
      when 'last-inputs' then new dashboard.Views.LastInputsWidgetView model: model
      when 'add' then new dashboard.Views.AddWidgetView model: model
      else new dashboard.Views.WidgetView model: model
        
        
  showLast: (e) =>
    @$el.fadeIn() if @gridster.$widgets.length is @collection.length