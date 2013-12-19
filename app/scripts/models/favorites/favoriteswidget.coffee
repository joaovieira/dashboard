'use strict';

###
Backbone Model of the Favorites widget. It inherits the base functionalities of the Widget 
class, and refreshes once its inputs are updated. The favorites inputs are copies of the
inputs that were favorited from other widgets (LastInputs).

Inputs is a collection, set as a model variable instead of an attribute. Thus, it needes extra
serializing (parse) and deserializing (toJSON) methods to handle data.
###
class dashboard.Models.FavoritesWidget extends dashboard.Models.Widget
  
  defaults:
    icon: "fa-star"
    type: 'favorites'
    size: [2,1]                       # default size
    name: ''                          # set unpon addition
  
  
  ###
  Init empty inputs collection or copy the ones that were previously favorited and
  set refresh handler to fire once their are updated.
  ###
  constructor: (attrs, options) ->

    # add collection reference
    @collection = options.collection
    @inputs = new dashboard.Collections.LastInputs attrs.inputs
    
    # referesh on input update
    @inputs.on 'all', @refresh
     
    # init with already favorited inputs
    if lastInputsWidget = @collection.findWhere {type: 'last-inputs'}
      favorites = lastInputsWidget.inputs.where favorite: true
      @inputs.add input for input in favorites
            
      @refresh if favorites.length

    Backbone.Model.apply this, arguments
  

  ###
  Validate model by checking if name is empty. Return array of failed validations.
  ###
  validate: (attrs) ->
    invalid = []
    invalid.push 'name': 'Name cannot be blank' if not attrs.name
    
    invalid if invalid.length


  ###
  When inputs are updated, save its data and trigger an update event to the view.
  ###
  refresh: =>  
    @save()
    @trigger 'update'
      
  
  ###
  Parse data.inputs to inputs variable without triggering events.
  ###        
  parse: (data, options) ->
    @inputs.reset data.inputs, silent: true
    data


  ###
  Merge model attributes with the inputs variable.
  ###
  toJSON: ->
    attrs = _.clone @attributes
    attrs.inputs = @inputs.toJSON()
    attrs