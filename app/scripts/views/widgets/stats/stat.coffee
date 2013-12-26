'use strict';

###
Backbone View representing a row in the Last Inputs widget.
###
class dashboard.Views.StatView extends Backbone.View

  tagName: 'tr'

  className: 'input'

  template: JST['app/scripts/templates/widgets/stats/rowinput']
  

  ###
  Render the view's template and pass in the current row index to numerate
  the stats rows.
  ###
  render: (index) ->
    @$el.html @template input: @model, index: index
    this
