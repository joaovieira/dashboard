'use strict';

class dashboard.Collections.Categories extends Backbone.Collection
  model: dashboard.Models.Category
  
  #url: '/api/categories'
  url: 'categories.json'