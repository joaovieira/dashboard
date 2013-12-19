'use strict';

###
Backbone Model of the base widget. All the data and methods are specific to each
widget, except the trigger event once it's size changes.
###
class dashboard.Models.Widget extends Backbone.Model

  defaults:
    type: 'empty'
    size: [1,1]


  ###
	Trigger resize event for the view to redraw components (eg. charts)
	###
  resize: ->
    @trigger 'resize'