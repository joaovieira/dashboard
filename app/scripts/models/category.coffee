'use strict';

class dashboard.Models.Category extends Backbone.Model
  idAttribute: '_id'


  constructor: ->
    @widgets = new dashboard.Collections.WidgetsCategory()
    @widgets.on 'change', @save
    Backbone.Model.apply this, arguments
  
  
  parse: (data, options) ->
    @widgets.reset data.widgets
    data
    
  
  toJSON: ->
    attrs = _.clone @attributes
    attrs.widgets = @widgets.toJSON()
    attrs