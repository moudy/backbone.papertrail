(function(_, Backbone){
  var PaperTrail = Backbone.PaperTrail = Backbone.Model.extend({

    store: function(options) {
      options || (options = {});

      var attrs = _.clone(this.attributes);

      if ( !_.isEqual(attrs, _.last(this.edits())) ) {
        this.edits().push(attrs);
      }

      return this;
    },

    restore: function (options) {
      options || (options = {});

      var index = options._index || 0;

      var attrs = this.edits()[index];
      if (!attrs) return this;

      for (var attr in this.attributes) attrs[attr] || this.unset(attr);

      this._edits = this.edits().slice(0, index);

      return this.set(attrs);
    },

    rollback: function (distance) {
      distance || (distance = 1);

      var index = (this.edits()[0] ? this.edits().length - distance : 0);
      if (index < 0) index = 0;

      debugger

      return this.restore({_index:index});
    },

    wasEdited: function() {
      return !!this.edits()[0];
    },

    edits: function() {
      return this._edits || (this._edits = []);
    },

    priorAttributes: function (options) {
      var result, index;
      options || (options = {});
      options.distance || (options.distance = 1);

      index = (this.edits()[0] ? this.edits().length - options.distance : 0);
      if (result = this.edits()[index]) return result;
    },

    prior: function (attr, options) {
      var result;
      options || (options = {});
      options.distance || (options.distance = 1);

      var index = (this.edits()[0] ? this.edits().length - options.distance : 0);

      if (result = this.edits()[index]) return result[attr];
    }

  });

}).call(this, _, Backbone);
