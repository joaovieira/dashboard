'use strict';

class dashboard.Routers.AppRouter extends Backbone.Router
  
  routes:
    '': 'home'
    'new': 'selectCategory'
    'new/:category': 'selectWidget'
    'new/:category/:widget': 'showWidget'
  
  home: ->
    dashboard.appView.home()
      
    
  selectCategory: ->
    dashboard.appView.addWidgetModal()
    
    
  selectWidget: (category) ->
    dashboard.appView.addWidgetModal(category)
    
    
  showWidget: (category, widget) ->
    dashboard.appView.addWidgetModal(category, widget)
    


# Globally capture clicks. If they are internal route them through Backbone's navigate method.
$(document).on "click", "a:not([data-bypass])", (event) ->
  href = $(this).attr "href"

  if href && href.indexOf("#") is 0
    event.preventDefault()

    Backbone.history.navigate href, true