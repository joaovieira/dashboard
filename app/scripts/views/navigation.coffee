'use strict';

class dashboard.Views.NavigationView extends Backbone.View

  events:
    'click li#tv': 'enterFullScreen'
    'click li#email': 'prepareEmail'
    
    
  enterFullScreen: ->
    # for full screen use use screenfull.request() 
    if screenfull.enabled then screenfull.request $('#widgets')[0] else @alertError()
    
    
  alertError: ->
    @trigger 'alert', { type: 'danger', text: 'Oh snap! Full screen not suported.' }