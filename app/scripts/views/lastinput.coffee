'use strict';

class dashboard.Views.LastInputView extends Backbone.View

  tagName: 'tr'
  class: 'input'
  template: JST['app/scripts/templates/lastinput']
  
  
  render: ->
    @$el.html @template input: @model
    @$('.fa-star').tooltip placement: 'bottom'
    this