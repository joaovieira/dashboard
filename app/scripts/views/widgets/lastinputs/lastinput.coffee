'use strict';

class dashboard.Views.LastInputView extends Backbone.View

  tagName: 'tr'
  className: 'input'
  template: JST['app/scripts/templates/widgets/lastinputs/rowinput']
  
  render: ->
    @$el.html @template input: @model
    @$('.fa-tooltip').tooltip placement: 'bottom'
    this