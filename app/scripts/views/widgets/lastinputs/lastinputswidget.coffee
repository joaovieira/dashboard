'use strict';

###
Backbone View for the Last Inputs widget that refreshes once its model is updated
via the 'update' event. Also tells widgets view to update its Favorite widget
if any input is added or removed from the favorites.
###
class dashboard.Views.LastInputsWidgetView extends dashboard.Views.WidgetView
  
  settingsTemplate: JST['app/scripts/templates/widgets/lastinputs/settings']
  

  ###
  Extend base widget's event with the handler to add/remove favorites.
  ###
  events: _.extend
    'click .fa-star': 'addFavorite'
  , dashboard.Views.WidgetView.prototype.events
    
  
  ###
  Refresh each input row if they changed.
  ###
  refresh: =>
    # add table
    @$('#inputs').html('<table class="table table-striped table-hover"></table>')

    # add rows for each input
    @model.inputs.each (input) ->
      inputView = new dashboard.Views.LastInputView model: input
      @$('#inputs table').append inputView.render().el
    , this
    
  
  ###
  Add favorite handler.
  ###  
  addFavorite: (e) ->  
    e.stopPropagation()
    
    # change row style
    @$(e.currentTarget).toggleClass 'selected'
    index = @$( ".favorite i" ).index(e.currentTarget)

    # update input
    input = @model.inputs.at(index)
    input.set 'favorite', !input.get 'favorite'
    
    # add/remove inputs from Favorites
    if input.get 'favorite'
      dashboard.appView.widgets.addFavorite input
    else
      dashboard.appView.widgets.removeFavorite input
    
    # save widget
    @model.save()