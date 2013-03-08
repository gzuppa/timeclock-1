# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :clock_event do
    user_id "1"
    time_in "2013-03-07 01:03:44"
    time_out "2013-03-07 05:03:44"
    notes "this is notes"
    status "0"
  end
end
