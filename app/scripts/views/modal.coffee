'use strict';

categories = [
    name: 'Category 1'
    id: 'category1'
    widgets: [
        name: 'Widget 1'
        id: 'widget1'
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras egestas consectetur auctor. Suspendisse placerat tempus malesuada. Donec at convallis augue, at rutrum mauris. Sed a metus imperdiet, egestas orci ut, posuere est.'
        sites: [
          name: "Site 1"
          url: "https://www.google.com"
        ,
          name: "Site 2"
          url: "https://www.apple.com"
        ]
      ]
  ]
  
  
  

class dashboard.Views.ModalView extends Backbone.View
  
  widgetTemplate: JST['app/scripts/templates/modal/widget']
  thumbnailTemplate: JST['app/scripts/templates/modal/thumbnails']
  
  events: ->
    "submit #createWidget": "createWidget"
    "change .form-group.has-error .form-control": "removeError"  
  
  
  initialize: ->
    # fetch available widgets and categories
    @categories = categories
    
    # init modal
    @$el.modal show: false
    
    @$el.on 'hidden.bs.modal', @returnHome
    
  
  show: ->
    @$el.modal('show')
    
  
  prepare: (category, widget) ->
    @category = _.find(@categories, (cat) -> cat.id is category)
    @widget = if @category then _.find(@category.widgets, (wid) -> wid.id is widget)
    
    # get to initial state
    breadcrumbs = @$('.breadcrumb').empty()
    @$('.search').show()
    @$('.btn-add').hide()
    
    # breadcrumbs
    breadcrumbs.append "<li class='active'>Add widget</li>"
    
    if @category
      breadcrumbs.find('li:last').removeClass('active').wrapInner "<a href='#new'></a>"
      breadcrumbs.append "<li class='active'>#{@category.name}</li>"
    
    if @widget
      breadcrumbs.find('li:last').removeClass('active').wrapInner "<a href='#new/#{@category.id}'></a>"
      breadcrumbs.append "<li class='active'>#{@widget.name}</li>"
      @$('.search').hide()
      @$('.btn-add').attr('form', 'createWidget').show()
      
        
    # content
    if @widget
      partial = @widgetTemplate widget: @widget
    else if @category
      partial = @thumbnailTemplate thumbnails: @category.widgets, base: @category.id
    else
      partial = @thumbnailTemplate thumbnails: @categories
    
    @$('.modal-body-content').fadeTo 400, 0, ->
      $(this).html(partial).find('select').selectpicker()
      $(this).fadeTo(400, 1)
  
  
  createWidget: (e) ->
    e.preventDefault()
    
    data = Backbone.Syphon.serialize(this);
    
    widget = new dashboard.Models.LastInputsWidget data, {validate: true}
    
    if errors = widget.validationError
      @renderErrors errors
    else
      dashboard.appView.widgets.createWidget widget
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