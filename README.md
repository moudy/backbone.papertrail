# PaperTrail

### Keep track of your model's changes

Shamelessly ripping off the name from the [Ruby Library](https://github.com/airblade/paper_trail/)

## Installation

Backbone.PaperTrail (hereafter referred to as "PaperTrail") is dependent on [Backbone.js](http://backbonejs.org), which is in turn dependent on [Underscore.js](http://underscorejs.org).

Include PaperTrail in your HTML head

    <script type="text/javascript" src="/path/to/backbone.papertrail.js"></script>

Or in your Rails 3.1 and new Asset Pipeline

    //= require backbone.papertrail

Or however else you include your JavaScript files.  Just ensure that the file is included *after* Backbone and Underscore.

##  Usage

Create a new model that extends Backbone.PaperTrail

    var formModel = Backbone.PaperTrail.extend({})

This model is now equipped with the PaperTrail methods.

### store

    formModel.store().set("firstName", "John")
    formModel.store().set("lastName", "Smith")

Prefixing the `set` method with `store()` tells PaperTrail to store this attribute modification.  The previous value is then stored in the model's `_edits` property.

### restore

Rollback all changes to all attributes on the model.  Bring it back to its original state.  To be more specific, it will return the attributes to the values they were at before your first store() command was executed.

    formModel.set("firstName", "John")
    formModel.set("firstName", "Bill")
    formModel.store().set("firstName", "Joe")
    formModel.store().set("firstName", "Roger")

    formModel.restore()

    formModel.get("firstName") # returns "Bill"

### rollback



### wasEdited



### edits



### priorAttributes



### prior



