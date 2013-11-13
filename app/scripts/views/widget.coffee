'use strict';

class dashboard.Views.WidgetView extends Backbone.View

  tagName: 'li'
  className: 'widget add'
  
  attributes:
    handleClass: 'handle'
  
  template: JST['app/scripts/templates/widget']

  events:
    'click .delete': 'remove'
    'mousedown': 'preventDrag'
            
  initialize: ->
    ###
    _.bindAll @, 'render', 'unrender', 'remove'

    @model.bind 'change', @render
    @model.bind 'remove', @unrender
    ###

  render: ->
    @$el.html @template widget: @model
    this
    
  preventDrag: (e) ->
    e.stopPropagation() if e.target.className.indexOf(@attributes.handleClass) is -1

  unrender: ->
    @$el.remove()
    
  remove: ->
    @model.destroy()