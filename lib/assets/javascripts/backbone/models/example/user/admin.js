define(["models/example/user/user"
], function (User) {
    var ThisClass = User.extend({
        defaults: {
            
        },
        initialize: function () {
            var self = this;
			ThisClass.__super__.initialize.apply(self, arguments);
			
        }
    });
    return ThisClass;
});