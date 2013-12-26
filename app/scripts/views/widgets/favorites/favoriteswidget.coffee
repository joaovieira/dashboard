'use strict';

###
Backbone View for the Favorites widget that refreshes once its model is updated
via the 'update' event.
###
class dashboard.Views.FavoritesWidgetView extends dashboard.Views.WidgetView

  settingsTemplate: JST['app/scripts/templates/widgets/favorites/settings']
  

  ###
  Extend base widget's event with the handler to show favorite input on the map.
  ###
  events: _.extend
    'click .fa-map-marker': 'viewOnMap'
  , dashboard.Views.WidgetView.prototype.events


  ###
  Render widget before getting the data. Refresh immediately because it might
  already have favorite inputs.
  ###
  render: ->
    super()
    @refresh()
    this


  ###
  Refresh the favorite inputs if they changed or show empty message if there are
  no favorites.
  ###
  refresh: =>
    if @model.inputs.length
      # add table
      @$('#inputs').html '<table class="table table-striped table-hover"></table>'

      # add rows for each input
      @model.inputs.each (input) ->
        inputView = new dashboard.Views.FavoriteInputView model: input
        @$('#inputs table').append inputView.render().el
      , this
    else
      @renderEmpty()
    
  
  ###
  Add simple message to the middle of the widget.
  ###
  renderEmpty: -> 
    @$('#inputs').html "<div class='loading'>#{"No favorite inputs".toUpperCase()}</div>"
      
    
  ###
  TODO: popup map centered around the selected inputs coordinates
  ###
  viewOnMap: ->
    