'use strict';

###
Backbone Model of the Last Inputs widget. It inherits the base functionalities of the Widget 
class, and continously fetches data from a remote feed over AJAX with the interval specified
in refreshTime.

Inputs is a collection, set as a model variable instead of an attribute. Thus, it needes extra
serializing (parse) and deserializing (toJSON) methods to handle data.
###
class dashboard.Models.LastInputsWidget extends dashboard.Models.Widget 
  
  defaults:
    icon: "fa-clock-o"
    type: 'last-inputs'
    size: [2,1]                       # default size
    site: ''                          # set unpon addition
    name: ''                          # set unpon addition
    refreshTime: 0                    # set unpon addition
     

  ###
  Init empty inputs collection and keep reference to parent collection.
  ###
  constructor: (attrs, options) ->
    @collection = options.collection
    @inputs = new dashboard.Collections.LastInputs attrs.inputs
    
    #@inputs.on 'change', @save
    
    Backbone.Model.apply this, arguments


  ###
  Validate model by checking if name, site and refreshTime are empty. Return array of 
  failed validations.
  ###
  validate: (attrs) ->
    invalid = []
    invalid.push 'name': 'Name cannot be blank' if not attrs.name
    invalid.push 'site': 'Please select a site' if not attrs.site 
    invalid.push 'refreshTime': 'Please select an interval' if not attrs.refreshTime
    
    invalid if invalid.length
  
   
  ###
  Loop AJAX calls to fetch remote input data from the site and with the refreshTime interval
  defined in the widget creation.
  ###    
  refresh: =>

    # AJAX call to get JSON input data from site
    $.getJSON @get('site'), (inputs) =>

      # update inputs if they already exist or create if not
      for data in inputs
        input = @inputs.findWhere feed_id: data.feed_id
        if input?
          input.set data
        else
          @inputs.add new dashboard.Models.LastInput data
      
      @save() 
      @trigger 'update'

      # loop
      setTimeout @refresh, @get 'refreshTime'


  ###
  Parse data.inputs to inputs variable without triggering events.
  ###
  parse: (data, options) ->
    @inputs.reset data.inputs
    data


  ###
  Merge model attributes with the inputs variable.
  ###
  toJSON: ->
    attrs = _.clone @attributes
    attrs.inputs = @inputs.toJSON()
    attrs