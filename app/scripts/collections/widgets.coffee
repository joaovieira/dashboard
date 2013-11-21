'use strict';

class dashboard.Collections.Widgets extends Backbone.Collection  
  #localStorage: new Backbone.LocalStorage("savedWidgets")
  
  model: (attrs, options) ->
    switch attrs.type
      when 'last-nputs' then new dashboard.Models.LastInputsWidget attrs, options
      when 'add' then new dashboard.Models.AddWidget attrs, options
      else new dashboard.Models.Widget attrs, options
  