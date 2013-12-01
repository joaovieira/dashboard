'use strict';

class dashboard.Views.ModalView extends Backbone.View
  
  thumbnailTemplate: JST['app/scripts/templates/modal/thumbnails']
  
  events: ->
    "submit #createWidget": "createWidget"
    "change .form-group.has-error .form-control": "removeError"  
  
  
  initialize: ->
    # fetch available widgets and categories
    @categories = new dashboard.Collections.Categories
    
    # init modal
    @$el.modal show: false
    
    @$el.on 'hidden.bs.modal', @returnHome
    
    @categories.fetch()
        
  
  show: ->
    @$el.modal('show')
    
  
  prepare: (category, widget) ->
    @category = @categories.findWhere name: category
    @widget = if @category then @category.widgets.findWhere name: widget
    
    # get to initial state
    breadcrumbs = @$('.breadcrumb').empty()
    @$('.search').show()
    @$('.btn-add').hide()
    
    # breadcrumbs
    breadcrumbs.append "<li class='active'>Add widget</li>"
    
    if @category
      breadcrumbs.find('li:last').removeClass('active').wrapInner "<a href='#new'></a>"
      breadcrumbs.append "<li class='active'>#{@category.get 'title'}</li>"
    
    if @widget
      breadcrumbs.find('li:last').removeClass('active').wrapInner "<a href='#new/#{@category.get 'name'}'></a>"
      breadcrumbs.append "<li class='active'>#{@widget.get 'title'}</li>"
      @$('.search').hide()
      @$('.btn-add').attr('form', 'createWidget').show()
      
        
    # content
    if @widget
      partial = @widgetCategoryView().render().el
    else if @category
      partial = @thumbnailTemplate thumbnails: @category.widgets.models, base: @category.get 'name'
    else
      partial = @thumbnailTemplate thumbnails: @categories.models
    
    @$('.modal-body-content').fadeTo 400, 0, ->
      $(this).html(partial).find('select').selectpicker()
      $(this).fadeTo(400, 1)
  
  
  widgetCategoryView: ->
    switch @widget.get 'name'
      when 'last-inputs' then new dashboard.Views.LastInputsCategoryView model: @widget
      when 'favorites' then new dashboard.Views.FavoritesCategoryView model: @widget
      when 'links-occupation' then new dashboard.Views.LinksOccupationCategoryView model: @widget
      else new dashboard.Views.CategoryView model: @widget
          
      
  createWidget: (e) ->
    e.preventDefault()
    
    data = Backbone.Syphon.serialize(this)
    options =
      collection: dashboard.appView.widgets.collection
      validate: true
    
    widgetModel = switch @widget.get 'name'
      when 'last-inputs' then new dashboard.Models.LastInputsWidget data, options
      when 'favorites' then new dashboard.Models.FavoritesWidget data, options
      when 'links-occupation' then new dashboard.Models.LinksOccupationWidget data, options
      else new dashboard.Models.Widget data, options
    
    if errors = widgetModel.validationError
      @renderErrors errors
    else
      dashboard.appView.widgets.createWidget widgetModel
      @$el.modal('hide')
      
   
  renderErrors: (errors) ->
    for error in errors
       for key of error
         @$(".form-control##{key}").nextAll('.control-label')
          .text(error[key]).fadeIn('fast')
          .closest('.form-group').addClass 'has-error'
   
   
  removeError: (e) ->
    target = if $(e.target).is('.dropdown-toggle') then $(e.target).parent().prev()[0] else e.target
    if target.value
      $(target).nextAll('.control-label').hide()
      .closest('.form-group').removeClass 'has-error'         
    
    
  returnHome: ->
    dashboard.router.navigate ''