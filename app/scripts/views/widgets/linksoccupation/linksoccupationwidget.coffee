'use strict';

###
Backbone View for the Links Occupation widget that refreshes once its model is updated
via the 'update' event. The view is responsible to draw the chart and rezise it once
the widget is rezised.
###
class dashboard.Views.LinksOccupationWidgetView extends dashboard.Views.WidgetView

  widgetTemplate: JST['app/scripts/templates/widgets/linksoccupation/widget']

  settingsTemplate: JST['app/scripts/templates/widgets/linksoccupation/settings']
  

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
    
    # draw chart
    @resizeCanvas()
    @drawChart()
    
    # set list
    @model.inputs.each (input) ->
      inputView = new dashboard.Views.LinkOccupationView model: input
      @$('#list table').append inputView.render().el
    , this


  ###
  Each grap has a specific resize. This dognhut graph is resized only when widget
  reaches the 2x2 size.
  ###
  resizeCanvas: ->
    chartArea = @$('#occupation')
    canvas = chartArea.find '#chart'

    size = @model.get 'size'
    if size[0] is 2 and size[1] is 2
      # make canvas widgth and height span 2 blocks (big graph)
      canvas.attr 'width', '240px'
      canvas.attr 'height', '240px'
      chartArea.addClass 'big'
    else
      # else always draw small
      canvas.attr 'width', '120px'
      canvas.attr 'height', '120px'
      chartArea.removeClass 'big'


  ###
  Feed Chart.js chart with the widget's model data.
  ###
  drawChart: =>
    context = @$("#occupation #chart").get(0).getContext "2d"
    
    # get average input occupation from model
    occupation = @model.getAverageOccupation()
    data = [
    	{ value: occupation, color: "#4a9fe1" }
    	{ value: 100-occupation, color: "#fff" }
    ]
    
    options =
      segmentShowStroke: false
      animationEasing: "easeOutQuart"
    
    # create chart with custom otions
    new Chart(context).Doughnut data, options
    @$('#occupation #value').text "#{occupation}%"


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