class ClockEvent < ActiveRecord::Base
  
  ##########################################################################

  attr_accessible :time_in, :time_out, :notes, :status

  belongs_to :user

  validates :notes, :length => { :maximum => 500 }
  validate :ensure_time_order

  ##########################################################################

  class << self

  	def CLOCK_STATUS 
  		{ 
        self_clock: 0, 
        pending: 1, 
        approved: 2 
      }
  	end

    def all_active_users
      active_users = []
      User.all.each do |user|
        active_users.push(user) if user.is_active?
      end
      return active_users
    end

	end

  def ensure_time_order
    return true if self.time_out.nil?
    errors.add(:time_out, "can't be before time in") if self.time_out < self.time_in
  end


end
