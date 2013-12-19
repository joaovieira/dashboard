'use strict';

###
Backbone View for the base widget definition view. The sub classes of this view
for each widget type are only responsible the custom settings part of this view.
###
class dashboard.Views.CategoryView extends Backbone.View

  tagName: 'div'
  className: 'row widget-category'

  template: JST['app/scripts/templates/modal/category']


  ###
  Draw the base template view, leaving the settings to the sub view.
  ###
  render: ->
    @$el.html @template widget: @model
    this