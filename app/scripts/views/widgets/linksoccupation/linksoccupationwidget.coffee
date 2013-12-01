'use strict';

class dashboard.Views.LinksOccupationWidgetView extends dashboard.Views.WidgetView

  widgetTemplate: JST['app/scripts/templates/widgets/linksoccupation/widget']
  settingsTemplate: JST['app/scripts/templates/widgets/linksoccupation/settings']
  
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
      inputView = new dashboard.Views.LinkOccupationView model: input
      @$('#list table').append inputView.render().el
    , this


  drawChart: =>
    context = $("#occupation #chart").get(0).getContext "2d"
    
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