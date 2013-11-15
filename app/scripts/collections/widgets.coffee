'use strict';

class dashboard.Collections.Widgets extends Backbone.Collection  
  url: '/api/widgets'
  
  model: (attrs, options) ->
    switch attrs.type
      when 'LastInputs' then new dashboard.Models.LastInputsWidget attrs, options
      when 'Add' then new dashboard.Models.AddWidget attrs, options
      else new dashboard.Models.Widget attrs, options
  