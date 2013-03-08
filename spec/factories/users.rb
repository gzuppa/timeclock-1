FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name 'Smith'
    email 'jsmith@local.host'
    password 'changeme'
    password_confirmation 'changeme'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
end