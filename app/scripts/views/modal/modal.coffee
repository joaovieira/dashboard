'use strict';

###
Backbone View representing the modal screen window. It prepares its content based
on its current navigation level. If can take two formats: a regular thumbnails layout or
a widget definition layout.

Both formats have different events, such as the search functionality that does not exist
in the widget definition; or the creation of the widget that does not exist in the
thumbnail layout.
###
class dashboard.Views.ModalView extends Backbone.View
  
  thumbnailTemplate: JST['app/scripts/templates/modal/thumbnails']
  

  ###
  View events, both during the thumbnail format or the widget definition one
  ###
  events: ->
    "submit #createWidget": "createWidget"
    "submit #searchWidgets": "searchWidgets"
    "change .form-group.has-error .form-control": "removeError"
  
  
  ###
  Initialize modal screen by fetching the categories from the remote RESTful API.
  Keep modal window hidden until explicitly invoked and navigate home once it is closed.
  ###
  initialize: ->

    # fetch available widgets and categories
    @categories = new dashboard.Collections.Categories
    
    # init modal
    @$el.modal show: false  
    @$el.on 'hidden.bs.modal', @returnHome
        
  
  ###
  Show modal screen explicitly.
  ###
  show: (category, widget) ->
    @$el.modal 'show'

    if not @categories.length
      @categories.fetch
        success: =>
          @prepare category, widget
    else
      @prepare category, widget
    
  
  ###
  Prepare the modal screen content, based on the navigation arguments. If there is
  no category defined show all categories, if there is a category, show all widgets,
  else show the widget definition.
  Keep breadcrumb updated and with proper back navigation.
  ###
  prepare: (category, widget) ->
    # try to find category and widget
    @category = @categories.findWhere name: category
    @widget = if @category then @category.widgets.findWhere name: widget
    
    # revert modal to initial state
    breadcrumbs = @$('.breadcrumb').empty()
    @$('.search').show()
    @$('.btn-add').hide()
    
    # build breadcrumbs
    breadcrumbs.append "<li class='active'>Add widget</li>"
    
    if @category
      breadcrumbs.find('li:last').removeClass('active').wrapInner "<a href='#new'></a>"
      breadcrumbs.append "<li class='active'>#{@category.get 'title'}</li>"
    
    if @widget
      breadcrumbs.find('li:last').removeClass('active').wrapInner "<a href='#new/#{@category.get 'name'}'></a>"
      breadcrumbs.append "<li class='active'>#{@widget.get 'title'}</li>"
      
        
    # set content
    if @widget
      # render the specific widget category defition template
      partial = @widgetCategoryView().render().el
      @$('.search').hide()
      @$('.btn-add').attr('form', 'createWidget').show()

    else if @category
      # thumbnails are the widgets for this category
      # add an attribute to each widget with the category name
      thumbnails = (widget.set 'category', @category.get('name'), {silent: true} for widget in @category.widgets.models)
      partial = @thumbnailTemplate thumbnails: thumbnails

    else
      partial = @thumbnailTemplate thumbnails: @categories.models
    
    # set the content with a fade animation
    @$('.modal-body-content').fadeTo 400, 0, ->
      $(this).html(partial).find('select').selectpicker()
      $(this).fadeTo(400, 1)
  
  
  ###
  Create the widget View based on its type.
  ###
  widgetCategoryView: ->
    switch @widget.get 'name'
      when 'last-inputs' then new dashboard.Views.LastInputsCategoryView model: @widget
      when 'favorites' then new dashboard.Views.FavoritesCategoryView model: @widget
      when 'links-occupation' then new dashboard.Views.LinksOccupationCategoryView model: @widget
      when 'low-priority' then new dashboard.Views.LowPriorityCategoryView model: @widget
      when 'stats' then new dashboard.Views.StatsCategoryView model: @widget
      else new dashboard.Views.CategoryView model: @widget
          
  
  ###
  Create the widget model and add to the widgets collection.
  ###    
  createWidget: (e) ->
    e.preventDefault()
    
    # serialize form data with backbone.Syphon into an object
    data = Backbone.Syphon.serialize e.target
    options =
      collection: dashboard.appView.widgets.collection
      validate: true
    
    # create model with validations
    widgetModel = switch @widget.get 'name'
      when 'last-inputs' then new dashboard.Models.LastInputsWidget data, options
      when 'favorites' then new dashboard.Models.FavoritesWidget data, options
      when 'links-occupation' then new dashboard.Models.LinksOccupationWidget data, options
      when 'low-priority' then new dashboard.Models.LowPriorityWidget data, options
      when 'stats' then new dashboard.Models.StatsWidget data, options
      else new dashboard.Models.Widget data, options
    
    # if there are some validation errors, render them. If not add to collection and return
    # to home screen
    if errors = widgetModel.validationError
      @renderErrors errors
    else
      dashboard.appView.widgets.createWidget widgetModel
      @$el.modal 'hide'
      
  
  ###
  Render validation errors, below each form input.
  ### 
  renderErrors: (errors) ->
    for error in errors
       for key of error
         @$(".form-control##{key}").nextAll('.control-label')
          .text(error[key]).fadeIn('fast')
          .closest('.form-group').addClass 'has-error'
   
  
  ###
  Remove the error if the correspondent input changed.
  ### 
  removeError: (e) ->
    # the target in the dropdown input is the previous element due to the
    # use of bootstrap-select component
    target = if $(e.target).is('.dropdown-toggle') then $(e.target).parent().prev()[0] else e.target

    if target.value
      $(target).nextAll('.control-label').hide()
      .closest('.form-group').removeClass 'has-error'         
    
    
  ###
  Navigate back to root.
  ###
  returnHome: ->
    dashboard.router.navigate ''


  ###
  Search in the whole categories collection for a widget including the search 
  text in its name.
  ###
  searchWidgets: (e) ->
    e.preventDefault()

    # create regex search expression from the search input text
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

    # set content with fadein animation
    if searchResults.length
      partial = @thumbnailTemplate thumbnails: searchResults
    else
      partial = "<div id='empty-search'>No widget match your search criteria.</div>"

    @$('.modal-body-content').fadeTo 400, 0, ->
      $(this).html(partial).find('select').selectpicker()
      $(this).fadeTo(400, 1)

    # navigate to dead route in order to change fragment and be able to get back to #new    
    dashboard.router.navigate 'search'