'use strict';

class dashboard.Views.NavigationView extends Backbone.View
  
  template: JST['app/scripts/templates/navigation']

  events:
    'click li#tv': 'enterFullScreen'
    'click li#email': 'prepareEmail'
    'click li#new-widget': 'newWidget'
    
  initialize: ->
    @render()
    
  render: ->
    @$el.html @template
    this
    
  enterFullScreen: ->
    # for full screen use use screenfull.request() 
    if screenfull.enabled then screenfull.request $('#widgets')[0] else @alertError()
    
  alertError: ->
    @trigger 'alert', text: 'Oh snap! Full screen not suported.'