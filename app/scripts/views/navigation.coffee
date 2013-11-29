'use strict';

class dashboard.Views.NavigationView extends Backbone.View

  emailFormTemplate: JST['app/scripts/templates/emailform']

  events:
    'click li#tv': 'enterFullScreen'
    'click li#email': 'toggleEmail'
    'submit #sendEmail': 'sendEmail'
    "change .form-group.has-error .form-control": "removeError"
    
  
  initialize: ->
    @$('li#email a').popover 
      html: true 
      content: @emailFormTemplate
    
    #$('#sendEmail').submit @sendEmail
    #@
    
	
  enterFullScreen: ->
    # for full screen use use screenfull.request() 
    if screenfull.enabled then screenfull.request() else @alertError()
    
    
  alertError: ->
    @trigger 'alert', { type: 'danger', text: 'Oh snap! Full screen not suported.' }
  
  
  toggleEmail: (e) ->
    @$(e.currentTarget).toggleClass 'selected'
      
  
  sendEmail: (e) =>
    e.preventDefault()

    # get email
    data = Backbone.Syphon.serialize this
    
    #validate input
    if not data.email
      @$('#sendEmail .control-label').text("Enter an email").fadeIn('fast')
      .closest('.form-group').addClass 'has-error'
    
    else
      # hide popover and widgets back faces
      @$('li#email a').popover 'hide'
      @$('.face-hidden').hide()
      
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
      
      # put back faces on again
      $('.face-hidden').show()
        
  
  removeError: (e) ->
    if e.target.value
      $(e.target).parent().nextAll('.control-label').hide()
      .closest('.form-group').removeClass 'has-error'
                  
  
  alertMailSuccess: (email) ->
    @trigger 'alert', { type: 'success', text: "Snapshot sent to <strong>#{email}</strong> with success." }
    


# dismiss popover when clicked outside
$('body').on 'click', (e) ->
  $('li#email a').each ->
    if (not $(this).is(e.target) and not $(this).has(e.target).length and not $('.popover').has(e.target).length)
      $(this).parent().removeClass 'selected'
      $(this).popover 'hide'