'use strict';

###
Backbone Collection of widgets from a category. A category has a set of widget 
definitions from which the user can choose and create a Widget.
###
class dashboard.Collections.WidgetsCategory extends Backbone.Collection
  model: dashboard.Models.WidgetCategory
