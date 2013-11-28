'use strict';

class dashboard.Views.LastInputView extends Backbone.View

  tagName: 'tr'
  className: 'input'
  template: JST['app/scripts/templates/lastinput']
  
  
  render: ->
    @$el.html @template input: @model
    @$('.fa-tooltip').tooltip placement: 'bottom'
    this