'use strict';

class dashboard.Views.LowPriorityView extends Backbone.View
  
  tagName: 'tr'
  className: 'input'
  template: JST['app/scripts/templates/widgets/lowpriority/rowinput']


  render: ->
    @$el.html @template { input: @model}
    @$('.fa-tooltip').tooltip placement: 'bottom'
    this
