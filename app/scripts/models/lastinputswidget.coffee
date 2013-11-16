'use strict';

class dashboard.Models.LastInputsWidget extends dashboard.Models.Widget 
  
  defaults:
    type: 'LastInputs'
    title: 'Last registered inputs'
    
    
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