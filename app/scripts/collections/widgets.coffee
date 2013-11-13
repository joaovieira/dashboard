'use strict';

class dashboard.Collections.Widgets extends Backbone.Collection
  model: dashboard.Models.Widget

  # API url to persist widgets
  #url: '/api/widgets'