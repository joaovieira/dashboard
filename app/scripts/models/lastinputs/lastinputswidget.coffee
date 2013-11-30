'use strict';

class dashboard.Models.LastInputsWidget extends dashboard.Models.Widget 
  
  defaults:
    icon: "fa-clock-o"
    type: 'last-inputs'
    size: [2,1]
    site: ''                          # set unpon addition
    name: ''                          # set unpon addition
    refreshTime: 0                    # set unpon addition
  
  
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
      
      @save  
      @trigger 'change'
      setTimeout @refresh, @get 'refreshTime'


  parse: (data, options) ->
    @inputs.reset data.inputs
    data


  toJSON: ->
    attrs = _.clone @attributes
    attrs.inputs = @inputs.toJSON()
    attrs