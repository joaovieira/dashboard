'use strict';

###
Backbone View representing a row in the Priority widget.
###
class dashboard.Views.LowPriorityView extends Backbone.View
  
  tagName: 'tr'

  className: 'input'

  template: JST['app/scripts/templates/widgets/lowpriority/rowinput']


  ###
  Render the view's template.
  ###
  render: ->
    @$el.html @template { input: @model }
    @$('.fa-tooltip').tooltip placement: 'bottom'
    this
