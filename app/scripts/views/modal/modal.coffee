'use strict';

class dashboard.Views.ModalView extends Backbone.View
  
  thumbnailTemplate: JST['app/scripts/templates/modal/thumbnails']
  
  events: ->
    "submit #createWidget": "createWidget"
    "submit #searchWidgets": "searchWidgets"
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
      thumbnails = (widget.set 'category', @category.get('name'), {silent: true} for widget in @category.widgets.models)
      partial = @thumbnailTemplate thumbnails: thumbnails
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
      when 'low-priority' then new dashboard.Views.LowPriorityCategoryView model: @widget
      when 'stats' then new dashboard.Views.StatsCategoryView model: @widget
      else new dashboard.Views.CategoryView model: @widget
          
      
  createWidget: (e) ->
    e.preventDefault()
    
    data = Backbone.Syphon.serialize e.target
    options =
      collection: dashboard.appView.widgets.collection
      validate: true
    
    widgetModel = switch @widget.get 'name'
      when 'last-inputs' then new dashboard.Models.LastInputsWidget data, options
      when 'favorites' then new dashboard.Models.FavoritesWidget data, options
      when 'links-occupation' then new dashboard.Models.LinksOccupationWidget data, options
      when 'low-priority' then new dashboard.Models.LowPriorityWidget data, options
      when 'stats' then new dashboard.Models.StatsWidget data, options
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


  searchWidgets: (e) ->
    e.preventDefault()

    data = Backbone.Syphon.serialize e.target
    regexSearch = new RegExp data.text, 'i'

    # search widgets by title
    searchResults = []
    
    @categories.each (category) ->
      category.widgets.each (widget) ->
        searchResults.push widget.set 'category', category.get('name'), {silent: true} if ~widget.get('title').search regexSearch

    # set breadcrumbs
    breadcrumbs = @$('.breadcrumb').html "<li><a href='#new'>Add widget</a></li>"
    breadcrumbs.append "<li class='active'>Search for '#{data.text}'</li>"

    # set content
    if searchResults.length
      partial = @thumbnailTemplate thumbnails: searchResults
    else
      partial = "<div id='empty-search'>No widget match your search criteria.</div>"

    @$('.modal-body-content').fadeTo 400, 0, ->
      $(this).html(partial).find('select').selectpicker()
      $(this).fadeTo(400, 1)

    # navigate to dead route in order to change fragment and be able to get back to #new    
    dashboard.router.navigate 'search'
