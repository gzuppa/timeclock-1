define([], function () {
    var ThisClass = Backbone.Router.extend({
    routes: {
				"": "show_default",
        "name.edit": "edit_name",
        "id.edit": "edit_id"
    },
		show_default: function(){
			window.models.user.clear_edit_mode();
		},
		edit_name: function(){
			window.models.user.enable_edit_name_mode();
		},
		edit_id: function(){
			window.models.user.enable_edit_id_mode();
		}
    });
    return ThisClass;
});