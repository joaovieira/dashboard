'use strict';

###
Backbone View for the Favorites catagory view in the modal screen. Each widget has
specific customizable settings that are defined in the categories template.
###
class dashboard.Views.LowPriorityCategoryView extends dashboard.Views.CategoryView

  formTemplate: JST['app/scripts/templates/widgets/lowpriority/category']


  ###
  Render the form with the customizable settings in the Category view.
  ###
  render: ->
    super()
    @$('.widget-form').html @formTemplate widget: @model
    this
