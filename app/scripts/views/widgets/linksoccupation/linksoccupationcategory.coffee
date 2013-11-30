'use strict';

class dashboard.Views.LinksOccupationCategoryView extends dashboard.Views.CategoryView

  formTemplate: JST['app/scripts/templates/widgets/linksoccupation/category']

  render: ->
    super()
    @$('.widget-form').html @formTemplate widget: @model
    this