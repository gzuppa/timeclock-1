require 'spec_helper'

describe ClockEventsController do

	describe 'GET index' do

		it 'should be successful' do
			get :index
      response.should be_success
		end

		it 'should return all active users' do
			get :index
			active_users = ClockEvent.all_active_users
      assigns(:active_users).length.should == active_users.length
		end

	end

	describe 'POST clock_in_or_out' do

		before (:each) do
    	@user = FactoryGirl.create(:user)
  	end

		it 'should clock inactive user in' do
			data = {:user => {:email => @user.email, :password => @user.password}}
			post :clock_in_or_out, data
			@user.is_active?.should == true
		end

		it 'should clock active user out' do
			data = {:user => {:email => @user.email, :password => @user.password}}
			post :clock_in_or_out, data
			post :clock_in_or_out, data
			@user.is_active?.should == false
		end

	end

	describe "as admin" do

		before (:each) do
    	user_attr = { :user_type => User.USER_TYPE[:admin] }
    	@user = FactoryGirl.create(:user, user_attr)
    	sign_in @user

    	clock_event_attr = { 
    		:user_id => @user.id, 
    		:time_in => 3.hours.ago,
    		:time_out => 2.hours.ago,
    		:status => ClockEvent.CLOCK_STATUS[:pending]
    	}
    	@clock_event = FactoryGirl.create(:clock_event, clock_event_attr)
    	@clock_event_attr = clock_event_attr.merge({ :id => @clock_event.id })
  	end

  	describe 'PUT update' do

			it "should be able to update(approve, change time_in/time_out) clock events" do
				clock_event_attr = @clock_event_attr.merge({
					:time_in => 2.hours.ago.to_s,
    			:time_out => 1.hours.ago.to_s,
    			:status => ClockEvent.CLOCK_STATUS[:approved]
  			})
				data = {:clock_event => clock_event_attr}
				put :update, data

				(
					assigns(:clock_event).time_in == Time.parse(clock_event_attr[:time_in]) &&
					assigns(:clock_event).time_out == Time.parse(clock_event_attr[:time_out]) &&
					assigns(:clock_event).status == clock_event_attr[:status]
				).should be_true
			end

		end

		describe 'DELETE destroy' do

			it "should be able to delete clock events" do
				data = {:id => @clock_event.id}
				delete :destroy, data
				ClockEvent.count.should == 0
			end

		end

	end

	
	describe "as user" do

		before (:each) do
    	@user = FactoryGirl.create(:user)
    	sign_in @user

    	clock_event_attr = { 
    		:user_id => @user.id, 
    		:time_in => 3.hours.ago,
    		:time_out => 2.hours.ago,
    		:status => ClockEvent.CLOCK_STATUS[:pending]
    	}
    	@clock_event = FactoryGirl.create(:clock_event, clock_event_attr)
    	@clock_event_attr = clock_event_attr.merge({ :id => @clock_event.id })
  	end

  	describe 'PUT update' do

			it "should not be able to update clock events" do
				clock_event_attr = @clock_event_attr.merge({
					:time_in => 2.hours.ago,
    			:time_out => 1.hours.ago,
    			:status => ClockEvent.CLOCK_STATUS[:approved]
  			})
				data = {:clock_event => clock_event_attr}
				put :update, data

				response.status.should == 401
			end

		end

		describe 'DELETE destroy' do

			it "should not be able to delete clock events" do
				data = {:id => @clock_event.id}
				delete :destroy, data
				ClockEvent.count.should > 0
			end
			
		end

		describe 'PUT update_notes' do

			it "should update notes for the clock event" do
				new_notes = "new notes"
				clock_event_attr = {
					:id => @clock_event.id,
					:notes => new_notes
  			}
				data = {:clock_event => clock_event_attr}
				put :update_notes, data
				assigns(:clock_event).notes.should == clock_event_attr[:notes]
			end

		end

		describe 'POST create' do

			it "should create clock event for a user" do
				clock_event_attr = { 
	    		:time_in => 3.hours.ago,
	    		:time_out => 2.hours.ago
	    	}
				clock_event = @user.add_clock_ticket(clock_event_attr)
				clock_event.new_record?.should_not be_true
			end

		end

		describe 'GET report' do

			it "should get clock events in the given date range" do
				clock_event_attr1 = { 
	    		:time_in => "2012/01/01 9:00 am",
	    		:time_out => "2012/01/01 6:00 pm"
	    	}
	    	clock_event_attr2 = { 
	    		:time_in => "2012/01/02 9:00 am",
	    		:time_out => "2012/01/02 6:00 pm"
	    	}
	    	clock_event_attr3 = { 
	    		:time_in => "2012/01/05 9:00 am",
	    		:time_out => "2012/01/05 6:00 pm"
	    	}
				@user.add_clock_ticket(clock_event_attr1)
				@user.add_clock_ticket(clock_event_attr2)
				@user.add_clock_ticket(clock_event_attr3)

				clock_events = @user.find_clock_events_in("2012/01/01","2012/01/02")
				clock_events.length.should == 2
			end

		end

	end



end
