'use strict';

###
Backbone Collection of Category models. It fetches the models from a
remote RESTful JSON API (can be a simple backend API).
###
class dashboard.Collections.Categories extends Backbone.Collection
  model: dashboard.Models.Category
  
  # the API to fetch widget categories and information from
  url: '/api/categories'