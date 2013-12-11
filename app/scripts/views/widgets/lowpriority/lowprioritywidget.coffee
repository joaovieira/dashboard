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
    @drawDifference()
    
    # set list
    @model.inputs.each (input) ->
      inputView = new dashboard.Views.LowPriorityView model: input
      @$('#top table').append inputView.render().el
    , this


  drawChart: =>
    context = $("#graph #chart").get(0).getContext "2d"
    
    dataSeries = @model.getAverageSeries()
    average = @model.getAverage()
	
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
      scaleStepWidth: average
      scaleStartValue: 0
      
    new Chart(context).Line data, options


  drawDifference: =>
    lastInputs = @model.getLastInputs()
    averageDifference = @model.getAverageDifference()
    arrow = if averageDifference.difference > 0 then "up" else "down"

    @$('.interval .number').text lastInputs.inputs.length
    @$('.interval .scale').text lastInputs.scale
    @$('.percentage .quantity').html "<i class='fa fa-sort-#{arrow}'></i> #{averageDifference.difference}<span>%</span>"
    @$('.percentage .quality').text averageDifference.text


  showTab: (e) ->
    e.preventDefault()
    $(this).tab 'show'
