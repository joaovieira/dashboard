'use strict';

class dashboard.Models.LastInput extends Backbone.Model
  idAttribute: 'feed_id'
  
  defaults:
    favorite: false
    occupation: 0
    coordinates:
      latitude: 0
      longitude: 0