Timeclock::Application.routes.draw do

	# clock events
  get "clocks" => "clock_events#index", :as => :show_clocks
  post "clock/switch" => "clock_events#clock_in_or_out", :as => :clock_switch
  
  post "clock" => "clock_events#create", :as => :create_clock
  put "clock" => "clock_events#update", :as => :update_clock
  put "clock/notes" => "clock_events#update_notes", :as => :update_clock_notes
  delete "clock" => "clock_events#destroy", :as => :destroy_clock

  # clock reports
  get "clock/reports" => "clock_events#show_reports", :as => :show_clock_reports
  get "user/:user_id/report" => "clock_events#get_report", :as => :show_user_clock_report

	# users
  get "users/index"
  get "users/show"

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users

end
