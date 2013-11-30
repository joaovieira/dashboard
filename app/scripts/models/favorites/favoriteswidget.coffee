'use strict';

class dashboard.Models.FavoritesWidget extends dashboard.Models.Widget
  
  defaults:
    icon: "fa-star"
    type: 'favorites'
    size: [2,1]
    name: ''                          # set unpon addition
  
  
  constructor: (attrs, options) ->
    @collection = options.collection
    @inputs = new dashboard.Collections.LastInputs(attrs.inputs)
    @inputs.on 'all', @refresh
     
    # init with already favorited inputs
    if lastInputsWidget = @collection.findWhere(type: 'last-inputs')
      favorites = lastInputsWidget.inputs.where favorite: true
      for input in favorites
        @inputs.add input
            
      @refresh if favorites.length
  
    Backbone.Model.apply this, arguments
  
  
  validate: (attrs) ->
    invalid = []
    invalid.push 'name': 'Name cannot be blank' if not attrs.name
    
    invalid if invalid.length


  refresh: =>
    #@save
    @trigger 'update'
    
          
  parse: (data, options) ->
    @inputs.reset data.inputs
    data


  toJSON: ->
    attrs = _.clone @attributes
    attrs.inputs = @inputs.toJSON()
    attrs