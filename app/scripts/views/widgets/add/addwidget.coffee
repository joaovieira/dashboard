'use strict';

###
Backbone View for the Add widget. Simply handles the creation of a new widget
by showing the modal screen, once clicked.
###
class dashboard.Views.AddWidgetView extends Backbone.View

  tagName: 'li'
  className: 'widget add'

  template: JST['app/scripts/templates/widgets/add/widget']
  
  ###
  Add event to whole wrapper to show modal screen.
  ###
  events:
    'click .wrapper': 'newWidget'
    

  ###
  Set the HTML element attribute id as the id of the view's inner model.
  Limit maximum size of widget. This is set here because gridster set this
  properties on initialization and not rendering.
  ###
  initialize: ->
    @$el.attr 'id', @model.cid

    @maxSize = [1,1]
    

  ###
  Render widgets template view.
  ###
  render: ->
    @$el.html @template widget: @model
    this
    
  
  ###
  Navigate to new route, showing the modal screen.
  ###  
  newWidget: ->
    dashboard.router.navigate 'new', { trigger: true }