'use strict';

class dashboard.Views.FavoritesCategoryView extends dashboard.Views.CategoryView

  formTemplate: JST['app/scripts/templates/widgets/favorites/category']
  
  render: ->
    super()
    @$('.widget-form').html @formTemplate widget: @model
    this
