'use strict';

class dashboard.Models.FavoritesWidget extends dashboard.Models.Widget
  
  defaults:
    icon: "fa-star"
    type: 'favorites'
    name: ''                          # set unpon addition
  
  
  constructor: ->
    @inputs = new dashboard.Collections.LastInputs()
    @inputs.on 'all', @refresh
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