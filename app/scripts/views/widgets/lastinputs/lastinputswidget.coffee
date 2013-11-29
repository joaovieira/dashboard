'use strict';

class dashboard.Views.LastInputsWidgetView extends dashboard.Views.WidgetView
  
  settingsTemplate: JST['app/scripts/templates/widgets/lastinputs/settings']
  
  events: _.extend
      'click .fa-star': 'addFavorite'
    , dashboard.Views.WidgetView.prototype.events
  
    
  initialize: ->
    @defaultSize = [2,1]
    
    # bind model events
    @model.on 'change', @refresh
    
    @model.refresh()
    
    
  render: ->
    super()
    this
    
    
  refresh: =>
    @$('#inputs').html('<table class="table table-striped table-hover"></table>')
    @model.inputs.each (input) ->
      inputView = new dashboard.Views.LastInputView model: input
      @$('#inputs table').append inputView.render().el
    , this
    
    
  addFavorite: (e) ->  
    e.stopPropagation()
    
    # change style
    @$(e.currentTarget).toggleClass 'selected'
    index = @$( ".favorite i" ).index(e.currentTarget)
    input = @model.inputs.at(index)
    input.set 'favorite', !input.get 'favorite'
    
    # add input to favorites widget if available
    if input.get 'favorite'
      dashboard.appView.widgets.addFavorite input
    else
      dashboard.appView.widgets.removeFavorite input
    