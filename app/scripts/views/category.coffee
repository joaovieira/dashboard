'use strict';

class dashboard.Views.CategoryView extends Backbone.View

  tagName: 'div'
  className: 'row widget-category'

  template: JST['app/scripts/templates/modal/category']

  render: ->
    @$el.html @template widget: @model
    this