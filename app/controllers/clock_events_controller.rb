class ClockEventsController < ApplicationController

	before_filter :authenticate_user!, :only => [:create, :update, :update_notes, :destroy]
	before_filter :require_admin!, :only => [:update, :destroy]

	def index
		@active_users = ClockEvent.all_active_users
		@user = User.new
	end 

	def clock_in_or_out
		attemp_user = params[:user]
		email = attemp_user[:email]
		password = attemp_user[:password]
		user = User.authenticate(email, password)
		respond_to do |format|
			if user.nil?
				msg = "Invalid username or password"
				flash[:alert] = msg
				format.html { 
					render :action => "index", 
					:status => :unauthorized 
				}
				format.json {
					render :json => {:alert => msg},
					:status => :unauthorized 
				}
			else
				user.clock
				action = user.is_active? ? "clocked in" : "clocked out"
				msg = "You have #{action}"
				flash[:notice] = msg
				format.html { 
					redirect_to show_clocks_url
				}
				format.json {
					render :json => {:notice => msg}
				}
			end
		end
	end

	def create
		# get & parse params
		clock_event_attr = params[:clock_event]

		# add model
		clock_event = current_user.add_clock_ticket(clock_event_attr)

		respond_to do |format|
			format.json{
				render :json => clock_event
			}
		end
	end

	def update
		# get & parse params
		clock_event_attr = params[:clock_event]
		clock_event_attr[:time_in] = Time.parse(clock_event_attr[:time_in]).utc unless clock_event_attr[:time_in].nil?
		clock_event_attr[:time_out] = Time.parse(clock_event_attr[:time_out]).utc unless clock_event_attr[:time_out].nil?

		# find & update model
		@clock_event = ClockEvent.find(clock_event_attr[:id])
		@clock_event.update_attributes(clock_event_attr)

		respond_to do |format|
			format.json{
				render :json => @clock_event
			}
		end
	end

	def update_notes
		# get params
		clock_event_attr = params[:clock_event]

		# find & update model
		@clock_event = ClockEvent.find(clock_event_attr[:id])
		@clock_event.notes = clock_event_attr[:notes]
		@clock_event.save!

		respond_to do |format|
			format.json{
				render :json => @clock_event
			}
		end
	end

	def destroy
		clock_event = ClockEvent.find(params[:id])
		clock_event.delete
		msg = "Event deleted"

		respond_to do |format|
			format.json{
				render :json => {:notice => msg}
			}
		end
	end

	def show_reports
		
	end

	def get_report
		# get params
		user_id = params[:user_id]
		start_date = params[:start_date]
		end_date = params[:end_date]

		# get models
		user = User.find(user_id)
		clock_events = user.get_clock_events_in(start_date, end_date)

		respond_to do |format|
			format.json{
				render :json => clock_events
			}
		end
	end

end
