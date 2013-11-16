'use strict';

class dashboard.Views.InputView extends Backbone.View

  tagName: 'tr'
  class: 'input'
  template: JST['app/scripts/templates/input']
  
  events:
    'click': 'highlight'
    'click .fa-star': 'addFavorite'
    
    
  render: ->
    @$el.html @template input: @model
    this
  
      
  highlight: (e) ->
    @$el.toggleClass('active').siblings().removeClass 'active'
    
    
  addFavorite: (e) ->
    @$(e.currentTarget).toggleClass 'selected'
