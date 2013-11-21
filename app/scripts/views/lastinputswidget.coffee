'use strict';

class dashboard.Views.LastInputsWidgetView extends dashboard.Views.WidgetView
  
  inputTemplate: JST['app/scripts/templates/lastinput']
  
  events:
    'click .fa-star': 'addFavorite'
    
    
  initialize: ->
    @events = _.extend({}, @genericEvents, @events);
    @delegateEvents()
    
    @defaultSize = [2,1]
    
    # bind model events
    @model.on 'change', @refresh
    
    @render()
    @model.refresh()
    
    
  render: ->
    super()
    this
    
    
  refresh: =>
    @$('#inputs').empty()
    @model.inputs.each (input) ->
      inputView = new dashboard.Views.LastInputView model: input
      @$('#inputs').append inputView.render().el
    , this
    
    
  addFavorite: (e) ->
    @$(e.currentTarget).toggleClass 'selected'
    index = @$( ".favorite i" ).index(e.currentTarget)
    input = @model.inputs.at(index)
    input.set 'favorite', !input.get 'favorite'
    e.stopPropagation()
  
    