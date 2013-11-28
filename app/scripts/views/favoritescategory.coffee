'use strict';

class dashboard.Views.FavoritesCategoryView extends dashboard.Views.CategoryView

  formTemplate: JST['app/scripts/templates/modal/favorites']
  
  render: ->
    super()
    @$('.widget-form').html @formTemplate widget: @model
    this
