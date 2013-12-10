'use strict';

class dashboard.Collections.Widgets extends Backbone.Collection  
  
  localStorage: new Backbone.LocalStorage("dashboard-widgets")
  
  model: (attrs, options) =>
    options =
      collection: this
    
    switch attrs.type
      when 'last-inputs' then new dashboard.Models.LastInputsWidget attrs, options
      when 'favorites' then new dashboard.Models.FavoritesWidget attrs, options
      when 'links-occupation' then new dashboard.Models.LinksOccupationWidget attrs, options
      when 'low-priority' then new dashboard.Models.LowPriorityWidget attrs, options
      when 'add' then new dashboard.Models.AddWidget attrs, options
      else new dashboard.Models.Widget attrs, options