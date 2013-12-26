'use strict';

###
Backbone View representing a row in the Last Inputs widget.
###
class dashboard.Views.LastInputView extends Backbone.View

  tagName: 'tr'

  className: 'input'

  template: JST['app/scripts/templates/widgets/lastinputs/rowinput']
  

  ###
  Render the view's template.
  ###
  render: ->
    @$el.html @template input: @model
    @$('.fa-tooltip').tooltip placement: 'bottom'
    this