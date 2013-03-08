define([], function () {
    ThisClass = Backbone.Model.extend({
        initialize: function () {

        },
        set_validation_message: function (errors) {
            var self = this;
            if (!_.isEqual(errors, self.get_validation_message())) {
                self.set({ "Errors": errors });
            }
        },
        get_validation_message: function (attr_name) {
            var self = this;
            var errors = self.get("Errors");
            if (!errors) {
                self.set({ "Errors": {} });
                errors = {};
            }

            if (attr_name) {
                return errors[attr_name];
            }

            return errors;
        },
        trigger_rerender: function () {
            var self = this;
            self.set("last_rerender", (new Date()).getTime());
        }
    });
    return ThisClass;
});