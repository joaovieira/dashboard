'use strict';

class dashboard.Views.StatsCategoryView extends dashboard.Views.CategoryView

  formTemplate: JST['app/scripts/templates/widgets/stats/category']

  render: ->
    super()
    @$('.widget-form').html @formTemplate widget: @model
    this
