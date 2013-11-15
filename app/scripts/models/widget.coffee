'use strict';

class dashboard.Models.Widget extends Backbone.Model
  idAttribute: '_id'

  defaults:
    type: 'Empty'
    title: 'Empty widget'