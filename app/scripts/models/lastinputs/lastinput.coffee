'use strict';

###
Backbone Model representing an input type. It is identified by the feed_id set
the by the data feed.
###
class dashboard.Models.LastInput extends Backbone.Model
  idAttribute: 'feed_id'
  
  defaults:
    favorite: false
    occupation: 0
    coordinates:
      latitude: 0
      longitude: 0