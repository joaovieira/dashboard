'use strict';

###
Backbone Router matches URLs to methods to navigate within the modal screen.
###
class dashboard.Routers.AppRouter extends Backbone.Router
  
  routes:
    '': 'home'
    'new(/:category)(/:widget)': 'showModal'
  
  ###
  Show default application view.
  ###
  home: ->
    dashboard.appView.home()
      

  ###
  Show the create widget modal screen with for the given category or widget.
  ###
  showModal: (category, widget) ->
    dashboard.appView.addWidgetModal category, widget
    

###
Globally capture clicks. If they are internal route them through Backbone's navigate method.
Use with the pushState feature of the Backbone Router.
###
$(document).on "click", "a:not([data-bypass])", (event) ->
  href = $(this).attr "href"

  if href && href.indexOf '#' is 0
    event.preventDefault()

    Backbone.history.navigate href, true