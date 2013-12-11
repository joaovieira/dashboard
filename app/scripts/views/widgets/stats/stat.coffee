'use strict';

class dashboard.Views.StatView extends Backbone.View

  tagName: 'tr'
  className: 'input'
  template: JST['app/scripts/templates/widgets/stats/rowinput']
  
  render: (index) ->
    @$el.html @template input: @model, index: index
    this
