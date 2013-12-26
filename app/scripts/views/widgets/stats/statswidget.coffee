'use strict';

###
Backbone View for the Stats widget that refreshes once its model is updated
via the 'update' event.
###
class dashboard.Views.StatsWidgetView extends dashboard.Views.WidgetView

  widgetTemplate: JST['app/scripts/templates/widgets/stats/widget']

  settingsTemplate: JST['app/scripts/templates/widgets/stats/settings']


  ###
  Refresh each input row if they changed. Pass the row view its index.
  ###
  refresh: =>
    @$('#inputs').html @widgetTemplate labels: @model.get 'labels'

    # set list
    @model.inputs.each (input, index) ->
      inputView = new dashboard.Views.StatView model: input
      @$('table').append inputView.render(index + 1).el
    , this
