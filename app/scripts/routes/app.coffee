'use strict';

class dashboard.Routers.AppRouter extends Backbone.Router
  
  routes:
    '': 'home'
    'new' : 'newWidget'
  
  home: ->
    dashboard.appView.home()
      
    
  newWidget: ->
    dashboard.appView.showModal()
