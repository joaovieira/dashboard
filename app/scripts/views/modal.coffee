'use strict';

class dashboard.Views.ModalView extends Backbone.View
  
  widgetTemplate: JST['app/scripts/templates/modal/widget']
  thumbnailTemplate: JST['app/scripts/templates/modal/thumbnails']
    
  
  initialize: ->
    # fetch available widgets and categories
    @categories = [
        name: 'category1'
        widgets: [
            name: 'widget1'
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras egestas consectetur auctor. Suspendisse placerat tempus malesuada. Donec at convallis augue, at rutrum mauris. Sed a metus imperdiet, egestas orci ut, posuere est.'
            sites: [
              name: "Site 1"
              url: "https://www.google.com"
            ,
              name: "Site 2"
              url: "https://www.apple.com"
            ]
          ,
            name: 'Widget 2'
            description: 'Description 2'
          ]
      ,
        name: 'categoria2'
        widgets: [
            name: 'widget3'
            description: 'description3'
          ,
            name: 'widget4'
            description: 'description4'
          ]
      ,
        name: 'categoria3'
        widgets: [
            name: 'widget1'
            description: 'description1'
          ,
            name: 'widget2'
            description: 'description2'
          ]
      ]
    
    # init modal
    @$el.modal show: false
    
    @$el.on 'hidden.bs.modal', @returnHome
    
  
  show: ->
    @$el.modal('show')
    
  
  prepare: (category, widget) ->
    @category = _.find(@categories, (cat) -> cat.name is category)
    @widget = if @category then _.find(@category.widgets, (wid) -> wid.name is widget)
    
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
      breadcrumbs.find('li:last').removeClass('active').wrapInner "<a href='#new/#{@category.name}'></a>"
      breadcrumbs.append "<li class='active'>#{@widget.name}</li>"
      @$('.search').hide()
      @$('.btn-add').show()
      
        
    # content
    if @widget
      partial = @widgetTemplate widget: @widget
    else if @category
      partial = @thumbnailTemplate thumbnails: @category.widgets, base: @category.name
    else
      partial = @thumbnailTemplate thumbnails: @categories
    
    @$('.modal-body-content').fadeTo 400, 0, ->
      $(this).html(partial)
      $('select', this).selectpicker()
      $(this).fadeTo(400, 1)
    
    
  returnHome: ->
    dashboard.router.navigate ''