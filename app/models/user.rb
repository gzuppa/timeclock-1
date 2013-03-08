class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ##########################################################################
  
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me

  has_many :clock_events, :dependent => :delete_all
  
  ##########################################################################

  class << self

  	def USER_TYPE 
  		{ employee: 0, admin: 1 }
  	end

    def authenticate(email, password)
      user = User.find_for_authentication(:email => email)
      return nil if user.nil?
      user.valid_password?(password) ? user : nil
    end

	end

  def is_admin?
    self.user_type == User.USER_TYPE[:admin]
  end

  def is_employee?
    self.user_type == User.USER_TYPE[:employee]
  end

  def active_events
    self.clock_events.where(:time_out => nil)
  end

  def is_active?
    self.active_events.count > 0
  end

  def clock
    if !self.is_active?
      clock_event = ClockEvent.new
      clock_event.user_id = self.id
      clock_event.time_in = Time.now.utc
      clock_event.status = ClockEvent.CLOCK_STATUS[:self_clock]
      clock_event.save
      return clock_event
    else
      last_event = self.active_events.order("time_in desc").limit(1).first
      last_event.time_out = Time.now.utc
      last_event.status = ClockEvent.CLOCK_STATUS[:self_clock]
      last_event.save
      return last_event
    end
  end

  def add_clock_ticket(clock_event_attr)
    unless clock_event_attr[:time_in].respond_to?("utc")
      clock_event_attr[:time_in] = Time.parse(clock_event_attr[:time_in]).utc unless clock_event_attr[:time_in].nil?
    end
    unless clock_event_attr[:time_out].respond_to?("utc")
      clock_event_attr[:time_out] = Time.parse(clock_event_attr[:time_out]).utc unless clock_event_attr[:time_out].nil?
    end
    clock_event_attr[:status] = ClockEvent.CLOCK_STATUS[:pending]
    clock_event = ClockEvent.new(clock_event_attr)
    clock_event.user_id = self.id

    if clock_event.time_out.nil?
      clock_event.errors.add(:time_out, "can't be empty") 
    else
      clock_event.errors.add(:time_in, "can't be future time") if clock_event.time_in > Time.now
      clock_event.errors.add(:time_out, "can't be future time") if clock_event.time_out > Time.now
    end

    clock_event.save if clock_event.errors.count == 0

    return clock_event
  end

  def find_clock_events_in(start_date, end_date)
    unless start_date.respond_to?("utc")
      start_date = Time.parse(start_date).utc unless start_date.nil?
    end
    unless end_date.respond_to?("utc")
      end_date = Time.parse(end_date).utc + 1.day unless end_date.nil?
    end
    self.clock_events.where("time_in between ? and ? or time_out between ? and ?", 
                            start_date.to_s, end_date.to_s, start_date.to_s, end_date.to_s)
  end


end
