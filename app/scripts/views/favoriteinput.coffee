'use strict';

class dashboard.Views.FavoriteInputView extends Backbone.View

  tagName: 'tr'
  className: 'input'
  template: JST['app/scripts/templates/favoriteinput']


  render: ->
    @$el.html @template { input: @model, occupation: @capacityStatus } 
    @$('.fa-tooltip').tooltip placement: 'bottom'
    this

    
  capacityStatus: =>
    occupation = @model.get 'occupation'
    if 0 <= occupation < 25
      "fa-circle-o occupation-quarter"
    else if 25 <= occupation < 50
      "fa-adjust occupation-half"
    else if 50 <= occupation < 75
      "fa-adjust occupation-almost-full"
    else "fa-circle occupation-full"