'use strict';

class dashboard.Views.FavoritesWidgetView extends dashboard.Views.WidgetView

  inputTemplate: JST['app/scripts/templates/favoriteinput']
  
  events: _.extend
      'click .fa-map-marker': 'viewOnMap'
    , dashboard.Views.WidgetView.prototype.events


  initialize: ->
    @defaultSize = [2,1]

    # bind model events
    @model.on 'update', @refresh
    
    # init with already favorited inputs
    if lastInputsWidget = dashboard.appView.widgets.getWidget 'last-inputs'
      favorites = lastInputsWidget.inputs.where favorite: true
      for input in favorites
        @model.inputs.add input
      
      setTimeout @refresh, 100 if favorites.length


  render: ->
    super()
    @renderEmpty()
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
    