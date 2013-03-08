define(["models/base"
], function (Base) {
    var ThisClass = Base.extend({
        defaults: {
            id: null,
						name: null
        },
    initialize: function () {
      var self = this;
			ThisClass.__super__.initialize.apply(self, arguments);
    },
		clear_edit_mode: function(){
			var self = this;
			self.set("edit_name", false);
			self.set("edit_id", false);
		},
		enable_edit_name_mode: function(){
			var self = this;
			self.set("edit_name", true);
			self.set("edit_id", false);
		},
		enable_edit_id_mode: function(){
			var self = this;
			self.set("edit_name", false);
			self.set("edit_id", true);
		}
    });
    return ThisClass;
});