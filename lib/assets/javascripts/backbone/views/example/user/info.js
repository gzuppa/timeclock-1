define(["views/base"
], function (ViewBase) {
    var ThisClass = ViewBase.extend({
        template:JST["backbone/templates/example/user/info"],
        initialize:function () {
            var self = this;
            ThisClass.__super__.initialize.apply(self, arguments);

            self.render();
            self.bind_custom_events();

            self.listenTo(self.model, "change", self.render);
        },
        custom_events:{
            "click [eid=reset_button]":"click_reset",
            "click [eid=user_id_block]":"click_edit_id",
            "click [eid=user_name_block]":"click_edit_name",
            "blur input[name=user_id]":"change_user_id",
            "blur input[name=user_name]":"change_user_name",
        },
        click_reset:function () {
            window.router.navigate("", {trigger:true});
        },
        click_edit_id:function () {
            window.router.navigate("id.edit", {trigger:true});
        },
        click_edit_name:function () {
            window.router.navigate("name.edit", {trigger:true});
        },
        change_user_id:function (e) {
            var self = this;
            self.model.set("id", $(e.currentTarget).val());
        },
        change_user_name:function (e) {
            var self = this;
            self.model.set("name", $(e.currentTarget).val());
        }
    });
    return ThisClass;
});