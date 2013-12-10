'use strict';

class dashboard.Views.LowPriorityWidgetView extends dashboard.Views.WidgetView

  widgetTemplate: JST['app/scripts/templates/widgets/lowpriority/widget']
  settingsTemplate: JST['app/scripts/templates/widgets/lowpriority/settings']
  
  events: _.extend
      'click .fa-share': 'share'
      'click #link-tabs a': 'showTab'
    , dashboard.Views.WidgetView.prototype.events
  
    
  initialize: ->
    @$el.attr 'id', @model.cid
      
    # bind model events
    @model.on 'update', @refresh
    
    @model.refresh()
    
    
  render: ->
    super()
    this
    
    
  refresh: =>
    @$('#inputs').html @widgetTemplate
    
    # set chart
    @drawChart()
    
    # set list
    @model.inputs.each (input) ->
      inputView = new dashboard.Views.LowPriorityView model: input
      @$('#top table').append inputView.render().el
    , this


  drawChart: =>
    context = $("#graph #chart").get(0).getContext "2d"
    
    dataSeries = @model.getAverageSeries(1)
    averageDifference = @model.getAverageDifference()
	
    data =
      labels: ('' for x in dataSeries)
      datasets: [
        strokeColor: "#36b58c"
        data: dataSeries
      ]
    
    options =
      scaleShowLabels: false
      scaleLineColor : "transparent"
      scaleShowGridLines: false
      bezierCurve: false
      pointDot: false
      datasetFill: false
      scaleOverride: true
      scaleSteps: 2
      scaleStepWidth: 5
      scaleStartValue: 0
      
    new Chart(context).Line data, options


  showTab: (e) ->
    e.preventDefault()
    $(this).tab 'show'
