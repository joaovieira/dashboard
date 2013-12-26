'use strict';

###
Backbone View for the Priority widget that refreshes once its model is updated
via the 'update' event. The view is responsible to draw the chart and rezise it once
the widget is rezised.
###
class dashboard.Views.LowPriorityWidgetView extends dashboard.Views.WidgetView

  widgetTemplate: JST['app/scripts/templates/widgets/lowpriority/widget']

  settingsTemplate: JST['app/scripts/templates/widgets/lowpriority/settings']
  

  ###
  Extend base widget's event with the handler to switch between tabs and share inputs.
  ###
  events: _.extend
    'click .fa-share': 'share'
    'click #link-tabs a': 'showTab'
  , dashboard.Views.WidgetView.prototype.events
  
    
  ###
  After base initialization, call resize to draw chart.
  ###
  initialize: ->
    super()
    @model.on 'resize', @resize
    @
    
   
  ###
  Refresh view's data (graph and list).
  ###  
  refresh: =>
    @$('#inputs').html @widgetTemplate
    
    # set chart area
    @resizeCanvas()
    @drawChart()
    @drawDifference()
    
    # set list
    @model.inputs.each (input) ->
      inputView = new dashboard.Views.LowPriorityView model: input
      @$('#top table').append inputView.render().el
    , this


  ###
  Each grap has a specific resize. This line graph is resized horizontally
  if the width spans 2 blocks and vertically if it's wide and the height 
  spans 2 blocks
  ###
  resizeCanvas: ->
    chartArea = @$('#graph')
    canvas = chartArea.find '#chart'

    # default
    canvas.attr 'height', '80px'
    chartArea.removeClass 'tall'

    size = @model.get 'size'
    if size[0] is 2
      # widen canvas area
      canvas.attr 'width', '460px'
      chartArea.addClass 'wide'

      # stretch it too
      if size[1] is 2
        canvas.attr 'height', '300px'
        chartArea.addClass 'tall'
    else
      # else draw small
      canvas.attr 'width', '210px'  
      chartArea.removeClass 'wide'


  ###
  Feed Chart.js chart with the widget's model data and statistics.
  ###
  drawChart: =>
    context = $("#graph #chart").get(0).getContext "2d"
    
    # get chart data and average
    dataSeries = @model.getAverageSeries()
    average = @model.getAverage()
	
    data =
      labels: ('' for x in dataSeries)    # hide labels
      datasets: [
        strokeColor: "#36b58c"
        data: dataSeries
      ]
    
    # make minimal graph without grids, labels, fills, etc.
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


  ###
  Draw data comparison below the graph area.
  ###
  drawDifference: =>
    lastInputs = @model.getLastInputs()
    averageDifference = @model.getAverageDifference()
    arrow = if averageDifference.difference > 0 then "up" else "down"

    @$('.interval .number').text lastInputs.inputs.length
    @$('.interval .scale').text lastInputs.scale
    @$('.percentage .quantity').html "<i class='fa fa-sort-#{arrow}'></i> #{averageDifference.difference}<span>%</span>"
    @$('.percentage .quality').text averageDifference.text


  ###
  Show tab (Bootstrap)
  ###
  showTab: (e) ->
    e.preventDefault()
    $(this).tab 'show'


  ###
  Callback to resize graph once Gridster bloc is resized.
  ###
  resize: =>
    @resizeCanvas()
    @drawChart()