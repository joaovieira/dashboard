'use strict';

class dashboard.Models.LastInputsWidget extends dashboard.Models.Widget 
  
  defaults:
    type: 'LastInputs'
    title: 'Last registered inputs'
    site: ''                          # set unpon addition
    name: ''                          # set unpon addition
    refreshTime: 0                # set unpon addition
   
  
  validate: (attrs) ->
    invalid = []
    invalid.push 'name': 'Name cannot be blank' if not attrs.name
    invalid.push 'site': 'Please select a site' if not attrs.site 
    invalid.push 'refreshTime': 'Please select an interval' if not attrs.refreshTime
    
    invalid if invalid.length
      
    
  constructor: ->
    @inputs = new dashboard.Collections.Inputs()
    @inputs.on 'change', @save
    Backbone.Model.apply this, arguments
  
  
  parse: (data, options) ->
    @inputs.reset data.inputs
    data
    
  
  toJSON: ->
    attrs = _.clone @attributes
    attrs.inputs = @inputs.toJSON()
    attrs