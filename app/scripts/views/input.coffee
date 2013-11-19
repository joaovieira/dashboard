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
    @$('.fa-star').tooltip placement: 'bottom'
    this
  
      
  highlight: (e) ->
    @$el.toggleClass('active').siblings().removeClass 'active'
    
    
  addFavorite: (e) ->
    @$(e.currentTarget).toggleClass 'selected'
    e.stopPropagation()
