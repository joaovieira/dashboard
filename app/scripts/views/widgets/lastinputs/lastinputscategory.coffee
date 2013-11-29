'use strict';

class dashboard.Views.LastInputsCategoryView extends dashboard.Views.CategoryView

  formTemplate: JST['app/scripts/templates/widgets/lastinputs/category']
  
  render: ->
    super()
    @$('.widget-form').html @formTemplate widget: @model
    this
