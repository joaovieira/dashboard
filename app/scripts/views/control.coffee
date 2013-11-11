'use strict';

class dashboard.Views.ControlView extends Backbone.View

  el: '#control-area'
  
  events:
    'click li#tv': 'fullScreen'
    'click li#email': 'emailOptions'
    'click li#add-widget': 'addWidget'
  
  errorTemplate: JST['app/scripts/templates/alerts/fullscreen']
    
  fullScreen: ->
    # for full screen use use screenfull.request() 
    if not screenfull.enabled then screenfull.request $('#widgets')[0] else @fullScreenError()
    
  fullScreenError: ->
    $('#alert-placeholder').html @errorTemplate message: 'Oh snap! Full screen not suported.'
    
