'use strict';

class dashboard.Models.LowPriorityWidget extends dashboard.Models.Widget

  defaults:
    icon: "fa-bar-chart-o"
    type: 'low-priority'
    size: [1,1]
    site: ''                          # set uppon addition
    name: ''                          # set uppon addition
    refreshTime: 0                    # set uppon addition
    
    # to delete
    previousInputs: [2,5,8,5,3,3,2,8,5,3,9,7,4,2,5,7]
	
	
  constructor: (attrs, options) ->
    @collection = options.collection
    @inputs = new dashboard.Collections.LastInputs attrs.inputs
    
    #@inputs.on 'change', @save
    
    Backbone.Model.apply this, arguments
	

  validate: (attrs) ->
    invalid = []
    invalid.push 'name': 'Name cannot be blank' if not attrs.name
    invalid.push 'site': 'Please select a site' if not attrs.site 
    invalid.push 'refreshTime': 'Please select an interval' if not attrs.refreshTime
    
    invalid if invalid.length
    
    
  refresh: =>
    $.getJSON @get('site'), (inputs) =>
      for data in inputs
        input = @inputs.findWhere feed_id: data.feed_id
        if input?
          input.set data
        else
          @inputs.add new dashboard.Models.LastInput data

      @save()  
      @trigger 'update'
      setTimeout @refresh, @get 'refreshTime'  
  
  
  getLastInputs: ->
    # filter inputs by date (eg. last hour)
    inputs: @inputs
    scale: 'last hour'
	
	
  getAverageSeries: ->
    # map inputs by interval
    average = @get 'previousInputs'
    average.concat [@inputs.length]


  getAverage: ->
    previous = @get('previousInputs')
    average = (previous.reduce (x,y) -> x + y) / previous.length


  getAverageDifference: ->
    average = @getAverage()
    diff = @getLastInputs().inputs.length / average - 1

    difference: Math.round diff * 100
    text: 'above daily average'


  parse: (data, options) ->
    @inputs.reset data.inputs
    data


  toJSON: ->
    attrs = _.clone @attributes
    attrs.inputs = @inputs.toJSON()
    attrs