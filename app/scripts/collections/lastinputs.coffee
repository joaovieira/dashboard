'use strict';

###
Backbone Collection of Inputs. Most of the widgets work on a set of
inputs. To simplify, all of the inputs are of the same time, although this 
can be extended if different widgets handles/support different input types.
###
class dashboard.Collections.LastInputs extends Backbone.Collection
  model: dashboard.Models.LastInput