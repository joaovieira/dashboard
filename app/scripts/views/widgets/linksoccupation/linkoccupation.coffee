'use strict';

###
Backbone View representing a row in the Links Occupation widget.
###
class dashboard.Views.LinkOccupationView extends Backbone.View

  tagName: 'tr'

  className: 'input'

  template: JST['app/scripts/templates/widgets/linksoccupation/rowinput']


  ###
  Render view's template with the @capacityStatus helper to draw (with the help
  of CSS classes) the occupation icon based on the input's current occupation.
  ###
  render: ->
    @$el.html @template { input: @model, occupation: @capacityStatus }
    @$('.fa-tooltip').tooltip placement: 'bottom'
    this


  ###
  Define 4 possible icons based on the occupation.
  ###
  capacityStatus: =>
    occupation = @model.get 'occupation'

    if 0 <= occupation < 25
      "fa-circle-o occupation-quarter"
    else if 25 <= occupation < 50
      "fa-adjust occupation-half"
    else if 50 <= occupation < 75
      "fa-adjust occupation-almost-full"
    else "fa-circle occupation-full"