'use strict';

class dashboard.Views.FavoritesWidgetView extends dashboard.Views.WidgetView

  settingsTemplate: JST['app/scripts/templates/widgets/favorites/settings']
  
  events: _.extend
      'click .fa-map-marker': 'viewOnMap'
    , dashboard.Views.WidgetView.prototype.events


  render: ->
    super()
    @refresh()
    this


  refresh: =>
    if @model.inputs.length
      @$('#inputs').html '<table class="table table-striped table-hover"></table>'
      @model.inputs.each (input) ->
        inputView = new dashboard.Views.FavoriteInputView model: input
        @$('#inputs table').append inputView.render().el
      , this
    else
      @renderEmpty()
    
  
  renderEmpty: -> 
    @$('#inputs').html "<div class='loading'>#{"No favorite inputs".toUpperCase()}</div>"
      
    
  viewOnMap: ->
    