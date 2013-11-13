'use strict';

json = {
  "widgets": [
    { "id": 1, "category": "category-1", "title": "title-1" },
    { "id": 2, "category": "category-2", "title": "title-2" },
    { "id": 3, "category": "category-2", "title": "title-3" },
    { "id": 4, "category": "category-3", "title": "title-4" },
    { "id": 5, "category": "category-4", "title": "title-5" },
    { "id": 6, "category": "category-4", "title": "title-6" }
  ]
}

class dashboard.Views.WidgetsView extends Backbone.View

  events:
    'click li#new-widget': 'newWidget'
    
  initialize: ->
    @collection = new dashboard.Collections.Widgets json.widgets
    @container = @$('#widgets-container')
    #@collection.fetch
  
    ##@collection.bind 'add', @appendWidget
    
    columns = @container?[0].getAttribute('data-columns')
    column_size = @container?[0].getAttribute('data-column-size')
    
    options =
      widget_margins: [10, 10],
      widget_base_dimensions: [parseInt(column_size), parseInt(column_size)]
      max_cols: parseInt(columns),
      resize:
        enabled: true,
        max_size: [2, 2]
        
    @container.append('<ul></ul>')    
    @gridster = @$('.gridster ul').gridster(options).data 'gridster'
    _(@collection.models).each (widget) => @appendWidget data: widget, isNew: false
    
    addWidget = new dashboard.Models.Widget class: 'add-widget', text: 'Add widget'
    @appendWidget data: addWidget, isNew: false
    
        
  createWidget: (formData)->
    @appendWidget formData
    @collection.create formData


  appendWidget: (widget) ->  
    newWidget = new dashboard.Views.WidgetView model: widget.data
    
    if widget.isNew
      @gridster.remove_widget( $('.gridster li:last') ) if widget.isNew
      addWidget = new dashboard.Views.WidgetView model: widget.data
    
    @gridster.add_widget newWidget.render().el
    
    @gridster.add_widget addWidget?.render().el if widget.isNew