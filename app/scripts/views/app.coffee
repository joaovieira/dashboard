'use strict';

class dashboard.Views.AppView extends Backbone.View

	el: '#dashboard-app'

	initialize: ->
	  @controlArea = new dashboard.Views.ControlView