'use strict';

###
Backbone Collection of Widget models. This collection is saved into the
client's Local Storage using the backbone.localStorage plugin.

Once data is added to the collection, it is converted to the correct type
of Model before it is added to the collection. This provides abstraction to
store widgets from different subclasses of Widget model.
###
class dashboard.Collections.Widgets extends Backbone.Collection  
  
  # save widgets to local storage
  localStorage: new Backbone.LocalStorage("dashboard-widgets")
  

  ###
  Convert widget data to the correct model before adding to Collection.
  ###
  model: (attrs, options) =>

    # add collection reference to model
    options =
      collection: this
    
    # diferentiate between known widget models
    switch attrs.type
      when 'last-inputs' then new dashboard.Models.LastInputsWidget attrs, options
      when 'favorites' then new dashboard.Models.FavoritesWidget attrs, options
      when 'links-occupation' then new dashboard.Models.LinksOccupationWidget attrs, options
      when 'low-priority' then new dashboard.Models.LowPriorityWidget attrs, options
      when 'add' then new dashboard.Models.AddWidget attrs, options
      when 'stats' then new dashboard.Models.StatsWidget attrs, options
      else new dashboard.Models.Widget attrs, options