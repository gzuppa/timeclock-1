define([], function () {
    ThisClass = Backbone.View.extend({
        initialize: function () {

        },
        render: function () {
            var self = this;
            self.close_sub_views();
            var data = self.model;
            self.$el.html(self.template(data));
            //self.setElement(self.template(data), true);
            self.bind_custom_events();
        },
        bind_custom_events: function () {
            var self = this;
            self.$el.undelegate();
            _.each(self.custom_events, function (fun, action) {
                var action_selector = action.split(" ");
                var action = action_selector[0];
                var selector = "*";
                if (action_selector.length > 1) {
                    action_selector.splice(0, 1);
                    selector = action_selector.join(" ");
                }
                self.$el.delegate(selector, action, _.bind(self[fun], self));
            });
        },
        add_sub_view: function (sub_view) {
            var self = this;
            //keep a ref to sub view for memory management for garbeged views
            if (!self.options.sub_views) {
                self.options.sub_views = [];
            }
            self.options.sub_views.push(sub_view);
        },
        remove_sub_view: function (sub_view) {
            var self = this;
            if (!self.options.sub_views) {
                self.options.sub_views = [];
            }

            var found_view = null;
            var found_view_id = null;
            for (var i in self.options.sub_views) {
                var view = self.options.sub_views[i];
                if (view == sub_view) {
                    found_view = view;
                    found_view_id = i;
                    break;
                }
            }

            if (found_view_id >= 0) {
                self.options.sub_views.splice(found_view_id, 1);
            }
        },
        close_self: function () {
            var view = this;
            view.close_sub_views();
            view.stopListening(); // Stop listen to all local registered callbacks
            view.unbind(); // Unbind all local event bindings
            view.remove(); // Remove view from DOM
            delete view;
        },
        close_sub_views: function () {
            var self = this;
            _.each(self.options.sub_views, function (view) {
                view.close_sub_views();
                view.stopListening(); // Stop listen to all local registered callbacks
                view.unbind(); // Unbind all local event bindings
                view.remove(); // Remove view from DOM
                delete view;
            });
            self.options.sub_views = [];
        }
    });
    return ThisClass;
});