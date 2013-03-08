require 'spec_helper'

describe ClockEvent do

  describe "clock in/out" do

    before (:each) do
	    @user = FactoryGirl.create(:user)
	  end

    it "should create clock_in event for a user if user never clocked in" do
      clock_event = @user.clock
      clock_event.time_out.should be_blank
    end

    it "should create clock_out event for a user if user clocked in last time" do
      clock_in_event = @user.clock
      clock_out_event = @user.clock
      clock_out_event.id.should == clock_in_event.id
    end

    it "should create clock-in event for a user if user clocked out last time" do
      clock_in_event = @user.clock
      clock_out_event = @user.clock
      clock_event = @user.clock
      clock_event.time_out.should be_blank
    end

  end
  
	describe "clock ticket" do

   	before (:each) do
	    @user = FactoryGirl.create(:user)
	  end

    it "should not allow time_in later than time_out" do
      past_time_in = 10.days.ago
      past_time_out = 10.days.ago - 5.hours
      clock_event_attr = {:time_in => past_time_in, :time_out => past_time_out}
      clock_event = @user.add_clock_ticket(clock_event_attr)
      clock_event.should_not be_valid
    end

    it "should create clock events for a past datetime" do
      past_time_in = 10.days.ago
      past_time_out = 10.days.ago + 5.hours
      clock_event_attr = {:time_in => past_time_in, :time_out => past_time_out}
      clock_event = @user.add_clock_ticket(clock_event_attr)
      clock_event.should be_valid
    end

    it "should not create clock events for a future datetime " do
      future_time_in = 10.days.from_now
      future_time_out = 10.days.from_now + 5.hours
      clock_event_attr = {:time_in => future_time_in, :time_out => future_time_out}
      clock_event = @user.add_clock_ticket(clock_event_attr)
      clock_event.new_record?.should be_true 
    end

  end

end
