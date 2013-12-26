'use strict';

###
Backbone Model of the Priority widget. It inherits the base functionalities of the Widget 
class, and continously fetches data from a remote feed over AJAX with the interval specified
in refreshTime.

It provides several methods to compare the last inputs against the average.

Inputs is a collection, set as a model variable instead of an attribute. Thus, it needes extra
serializing (parse) and deserializing (toJSON) methods to handle data.
###
class dashboard.Models.LowPriorityWidget extends dashboard.Models.Widget

  defaults:
    icon: "fa-bar-chart-o"
    type: 'low-priority'
    size: [1,1]                       # default size
    site: ''                          # set uppon addition
    name: ''                          # set uppon addition
    refreshTime: 0                    # set uppon addition
    
    # to delete, process from the old inputs
    previousInputs: [2,5,8,5,3,3,2,8,5,3,9,7,4,2,5,7]
	
	
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
  Extract the last inputs given the scale provided in the creation of the widget and
  return this info in an object.
  ###
  getLastInputs: ->
    
    # TODO: filter inputs by date (eg. last hour), take scale from model attributes
    inputs: @inputs
    scale: 'last hour'
	

  ###
  Map total inputs per series interval (eg. inputs/day).
  ###
  getAverageSeries: ->

    # TODO: map inputs by interval and in an array
    average = @get 'previousInputs'
    average.concat [@inputs.length]

  
  ###
  Get average of inputs per series interval (eg. day), without the last series (today).
  ###
  getAverage: ->

    # TODO: map inputs by interval and in an array
    previous = @get 'previousInputs'

    # get average using underscore.js reduce
    average = (previous.reduce (x,y) -> x + y) / previous.length


  ###
  Compare the average of previous series with the last. Calculate modulus and sign.
  ###
  getAverageDifference: ->

    # get average difference
    average = @getAverage()
    diff = @getLastInputs().inputs.length / average - 1

    # TODO: return object with the difference and sign
    difference: Math.round diff * 100
    text: 'above daily average'


  ###
  Parse data.inputs to inputs variable without triggering events.
  ### 
  parse: (data, options) ->
    @inputs.set data.inputs
    data


  ###
  Merge model attributes with the inputs variable.
  ###
  toJSON: ->
    attrs = _.clone @attributes
    attrs.inputs = @inputs.toJSON()
    attrs