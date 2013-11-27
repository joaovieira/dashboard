'use strict';

class dashboard.Views.NavigationView extends Backbone.View

  emailFormTemplate: JST['app/scripts/templates/emailform']

  events:
    'click li#tv': 'enterFullScreen'
    'click li#email': 'toggleEmail'
    'submit #sendEmail': 'sendEmail'
    
  
  initialize: ->
    @$('li#email a').popover 
      html: true 
      content: @emailFormTemplate
    
    
  enterFullScreen: ->
    # for full screen use use screenfull.request() 
    if screenfull.enabled then screenfull.request() else @alertError()
    
    
  alertError: ->
    @trigger 'alert', { type: 'danger', text: 'Oh snap! Full screen not suported.' }
  
  
  toggleEmail: (e) ->
    @$(e.currentTarget).toggleClass 'selected'
      
  
  sendEmail: (e) ->
    e.preventDefault()

    # get email and hide tooltip
    data = Backbone.Syphon.serialize this
    @$('li#email a').trigger 'click'
    
    # take screenshot
    html2canvas document.body, #$('#widgets'),
      onrendered: (canvas) =>
        img = canvas.toDataURL("image/png")
        date = new Date()
         
        $.post "/api/snapshot",
          name: "dashboard-#{date.getTime()}.png"
          image: img.split(',')[1]
          email: data.email
        , @alertMailSuccess data.email
        
        
  alertMailSuccess: (email) ->
    @trigger 'alert', { type: 'success', text: "Snapshot sent to <strong>#{email}</strong> with success." }