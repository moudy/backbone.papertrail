(function(e,t){var n=t.PaperTrail=t.Model.extend({store:function(t){t||(t={});var n=e.clone(this.attributes),r=e.isEqual(n,e.last(this.edits()));if(!r)this.edits().push(n);return this},restore:function(e){e||(e={});var t=e._index||0,n=this.edits()[t];if(!n)return this;for(var r in this.attributes){if(!n[r])this.unset(r)}this._edits=this.edits().slice(0,t);return this.set(n)},rollback:function(e){e||(e=1);var t=this.edits()[0]?this.edits().length-e:0;if(t<0)t=0;return this.restore({_index:t})},wasEdited:function(){return!!this.edits()[0]},edits:function(){return this._edits||(this._edits=[])},priorAttributes:function(e){e||(e={});var t=e.distance||1,n=this.edits()[0]?this.edits().length-t:0;return this.edits()[n]},prior:function(e,t){t||(t={});var n=t.distance||1,r=this.edits()[0]?this.edits().length-n:0,i=this.edits()[r];if(i)return i[e]}})}).call(this,_,Backbone)