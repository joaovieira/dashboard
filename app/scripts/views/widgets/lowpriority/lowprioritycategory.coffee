'use strict';

class dashboard.Views.LowPriorityCategoryView extends dashboard.Views.CategoryView

  formTemplate: JST['app/scripts/templates/widgets/lowpriority/category']

  render: ->
    super()
    @$('.widget-form').html @formTemplate widget: @model
    this
