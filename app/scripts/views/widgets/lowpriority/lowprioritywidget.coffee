'use strict';

class dashboard.Views.LowPriorityWidgetView extends dashboard.Views.WidgetView

  widgetTemplate: JST['app/scripts/templates/widgets/lowpriority/widget']
  settingsTemplate: JST['app/scripts/templates/widgets/lowpriority/settings']
  
  events: _.extend
      'click .fa-share': 'share'
      'click #link-tabs a': 'showTab'
    , dashboard.Views.WidgetView.prototype.events
  
    
  initialize: ->
    super()
    @model.on 'resize', @resize
    @
    
    
  render: ->
    super()
    this
    
    
  refresh: =>
    @$('#inputs').html @widgetTemplate
    
    # set chart
    @resizeCanvas()
    @drawChart()
    @drawDifference()
    
    # set list
    @model.inputs.each (input) ->
      inputView = new dashboard.Views.LowPriorityView model: input
      @$('#top table').append inputView.render().el
    , this


  resizeCanvas: ->
    chartArea = @$('#graph')
    canvas = chartArea.find '#chart'

    canvas.attr 'height', '80px'
    chartArea.removeClass 'tall'

    size = @model.get 'size'
    if size[0] is 2
      canvas.attr 'width', '460px'
      chartArea.addClass 'wide'

      if size[1] is 2
        canvas.attr 'height', '300px'
        chartArea.addClass 'tall'
    else
      canvas.attr 'width', '210px'  
      chartArea.removeClass 'wide'


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


  resize: =>
    @resizeCanvas()
    @drawChart()