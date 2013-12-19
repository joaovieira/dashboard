'use strict';

###
Backbone Model for the Add widget in the dashboard grid. This widget is only a button
to the modal sreen. However it is modeled as a widget object in order to have the same
flow as the rest of the widgets in the Gridster.js grid.

The Add widget has fixed size of 1x1 and no title icon.
###
class dashboard.Models.AddWidget extends dashboard.Models.Widget

  defaults:
    type: 'add'
    title: 'Add widget'
    size: [1,1]