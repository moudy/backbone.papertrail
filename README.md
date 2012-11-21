# PaperTrail

### Keep track of your model's changes

Shamelessly ripping off the name from the [Ruby Library](https://github.com/airblade/paper_trail/)

## Installation

Backbone.PaperTrail (hereafter referred to as "PaperTrail") is dependent on [Backbone.js](http://backbonejs.org), which is in turn dependent on [Underscore.js](http://underscorejs.org).

Include PaperTrail in your HTML head

``` html
    <script type="text/javascript" src="/path/to/backbone.papertrail.js"></script>
```

Or in your Rails 3.1 and new Asset Pipeline

``` ruby
    //= require backbone.papertrail
```

Or however else you include your JavaScript files.  Just ensure that the file is included *after* Backbone and Underscore.

##  Usage

Create a new model that extends Backbone.PaperTrail

``` javascript
    var formModel = Backbone.PaperTrail.extend({});
```

This model is now equipped with the PaperTrail methods.

### store

Track the change to the model's attribute.  If `store()` does not prefix the `set()` method, the change will not be tracked by PaperTrail.

``` javascript
    formModel.store().set("firstName", "John");
    formModel.store().set("lastName", "Smith");
```

Prefixing the `set` method with `store()` tells PaperTrail to store this attribute modification.  The previous value is then stored in the model's `_edits` property.

### restore

Rollback all changes to all attributes on the model.  Bring it back to its original state.  To be more specific, it will return the attributes to the values they were at before your first store() command was executed on the model, not on the specific attribute.

``` javascript
    formModel.set("firstName", "John");
    formModel.set("firstName", "Bill");
    formModel.store().set("firstName", "Joe");
    formModel.store().set("firstName", "Roger");

    formModel.restore();

    formModel.get("firstName") # returns "Bill";
```

Note that any `set()` calls made after your first `store()` will not be used for `restore()`.

``` javascript
    formModel.set("firstName", "John");
    formModel.store().set("firstName", "Joe");
    formModel.set("lastName", "Smith");
    formModel.store().set("lastName", "Black");

    formModel.restore();

    formModel.get("firstName"); # returns "Bill"
    formModel.get("lastName"); # returns undefined
```

### rollback

Rollback will allow you to perform a `restore()` but allows you to roll back a specified number of edits instead of all.  If no distance is specified, defaults to 1 step back.

``` javascript
    formModel.set("firstName", "John");
    formModel.set("lastName", "Smith");
    formModel.store().set("firstName", "Joe");
    formModel.store().set("lastName", "Black");
    formModel.store().set("firstName", "Susan");
    formModel.store().set("lastName", "Jones");
    formModel.store().set("firstName", "Rebecca");
    formModel.store().set("lastName", "Garcia");

    formModel.rollback();
    formModel.get("firstName"); # returns "Rebecca"
    formModel.get("lastName"); # returns "Jones"

    formModel.rollback(2);
    formModel.get("firstName"); # returns "Susan"
    formModel.get("lastName"); # returns "Black"
```

### wasEdited

Returns boolean for whether or not the model has tracked edits.

### edits

Returns an array of objects, with each object representing a full iteration of the attribute values for the model.

``` javascript
    formModel.set("firstName", "John");
    formModel.set("lastName", "Smith");
    formModel.edits(); # returns empty array

    formModel.store().set("firstName", "Joe");
    formModel.store().set("lastName", "Black");
    formModel.edits(); # returns array with one object, {firstName: "Joe", lastName: "Black"}

    formModel.store().set("firstName", "Susan");
    formModel.edits(); # returns array with two object, {firstName: "Joe", lastName: "Black"} and {firstName: "Susan", lastName: "Black"}
```

### priorAttributes

Returns an object of attributes representing the model's attributes one step back.

``` javascript
    formModel.set("firstName", "John");
    formModel.set("lastName", "Smith");
    formModel.priorAttributes(); # returns undefined

    formModel.store().set("firstName", "Bill");
    formModel.priorAttributes(); # returns {firstName: "John", lastName: "Smith"}

    formModel.store().set("lastName", "Jones");
    formModel.store().set("firstName", "Joe");
    formModel.priorAttributes(); # returns {firstName: "Bill", lastName: "Jones"}
```

### prior

Returns the value of the specified attribute from the prior iteration of the model.

``` javascript
    formModel.set("firstName", "John");
    formModel.set("lastName", "Smith");
    formModel.prior("firstName"); # returns undefined

    formModel.store().set("firstName", "Bill");
    formModel.prior("firstName"); # returns "John"
    formModel.prior("lastName"); # returns "Smith"

    formModel.store().set("lastName", "Jones");
    formModel.prior("firstName"); # returns "Bill"
    formModel.prior("lastName"); # returns "Smith"
```