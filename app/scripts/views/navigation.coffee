'use strict';

###
Backbone View for the navigation bar control. It manages the options available in the
navigation, including full screen support, snapshot and email send.
###
class dashboard.Views.NavigationView extends Backbone.View

  emailFormTemplate: JST['app/scripts/templates/emailform']


  ###
  Bind event handlers to the navigation buttons and inner forms (email).
  ###
  events:
    'click li#tv': 'enterFullScreen'
    'click li#email': 'toggleEmail'
    'submit #sendEmail': 'sendEmail'
    "change .form-group.has-error .form-control": "removeError"
    
  
  ###
  Set up email popover element with HTML from an external template.
  ###
  initialize: ->
    @$('li#email a').popover 
      html: true 
      content: @emailFormTemplate
    
	
  ###
  Enter fullscreen or raise Error to the app view.
  ###
  enterFullScreen: ->
    if screenfull.enabled then screenfull.request() else @alertError()
    
  
  ###
  Trigger alert event for the app view to create and show the alert message.
  ###  
  alertError: ->
    @trigger 'alert', { type: 'danger', text: 'Oh snap! Full screen not suported.' }
  
  
  ###
  Toggle email button selection when it is opened.
  ###
  toggleEmail: (e) ->
    @$(e.currentTarget).toggleClass 'selected'
      
  
  ###
  Get email, take screenshot using html2canvas library and post the email data as a request to
  the backend API to send an email to the recipient.
  ###
  sendEmail: (e) =>
    e.preventDefault()

    # get email
    data = Backbone.Syphon.serialize this
    
    #validate input
    if not data.email
      @$('#sendEmail .control-label').text("Enter an email").fadeIn('fast')
      .closest('.form-group').addClass 'has-error'
    
    else
      # hide popover
      @$('li#email a').popover 'hide'
      
      # take screenshot
      html2canvas document.body, #$('#widgets'),
        onrendered: (canvas) =>
          img = canvas.toDataURL("image/png")
          date = new Date()
         
          # request email send with image
          $.post "/api/snapshot",
            name: "dashboard-#{date.getTime()}.png"   # append current date
            image: img.split(',')[1]                  # Base64
            email: data.email                         # recipient
          , @alertMailSuccess data.email              # callback
        
  
  ###
  Remove rendered errors from the email form.
  ###
  removeError: (e) ->
    if e.target.value
      $(e.target).parent().nextAll('.control-label').hide()
      .closest('.form-group').removeClass 'has-error'
                  
  
  ###
  Trigger alert event for the app view to create and show the alert message.
  ###
  alertMailSuccess: (email) ->
    @trigger 'alert', { type: 'success', text: "Snapshot sent to <strong>#{email}</strong> with success." }
    


# General event handler to dismiss email popover when clicked outside.
$('body').on 'click', (e) ->
  $('li#email a').each ->
    if (not $(this).is(e.target) and not $(this).has(e.target).length and not $('.popover').has(e.target).length)
      $(this).parent().removeClass 'selected'
      $(this).popover 'hide'