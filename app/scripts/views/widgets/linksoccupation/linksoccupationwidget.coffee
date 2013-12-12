'use strict';

class dashboard.Views.LinksOccupationWidgetView extends dashboard.Views.WidgetView

  widgetTemplate: JST['app/scripts/templates/widgets/linksoccupation/widget']
  settingsTemplate: JST['app/scripts/templates/widgets/linksoccupation/settings']
  
  events: _.extend
      'click .fa-share': 'share'
      'click #link-tabs a': 'showTab'
    , dashboard.Views.WidgetView.prototype.events
  

  initialize: ->
    super()
    @model.on 'resize', @resize
    @

    
  refresh: =>
    @$('#inputs').html @widgetTemplate
    
    # set chart
    @resizeCanvas()
    @drawChart()
    
    # set list
    @model.inputs.each (input) ->
      inputView = new dashboard.Views.LinkOccupationView model: input
      @$('#list table').append inputView.render().el
    , this


  resizeCanvas: ->
    chartArea = @$('#occupation')
    canvas = chartArea.find '#chart'

    size = @model.get 'size'
    if size[0] is 2 and size[1] is 2
      canvas.attr 'width', '240px'
      canvas.attr 'height', '240px'
      chartArea.addClass 'big'
    else
      canvas.attr 'width', '120px'
      canvas.attr 'height', '120px'
      chartArea.removeClass 'big'


  drawChart: =>
    context = @$("#occupation #chart").get(0).getContext "2d"
    
    occupation = @model.getAverageOccupation()
    data = [
    	{ value: occupation, color: "#4a9fe1" }
    	{ value: 100-occupation, color: "#fff" }
    ]
    
    options =
      segmentShowStroke: false
      animationEasing: "easeOutQuart"
      
    new Chart(context).Doughnut data, options
    @$('#occupation #value').text "#{occupation}%"


  showTab: (e) ->
    e.preventDefault()
    $(this).tab 'show'


  resize: =>
    @resizeCanvas()
    @drawChart()