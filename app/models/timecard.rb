class Timecard < ApplicationRecord
  include ActiveModel::Validations

  # Use custom attributes to split datetimes into dates and times
  attr_accessor :field_clock_in_date, :field_clock_in_time, :field_clock_out_date, :field_clock_out_time
  
  # Relationships:
  belongs_to :user
  
  # Validations
  validates :description, presence: true, length: {maximum: 250}
  validates :clock_in, presence: true 
  validates :clock_out, presence: true
  validates :user, presence: true
  validates_with TimecardValidator #Defined in concerns/timecard_validator.rb

  # Callbacks
  before_validation :combine_fields

  def combine_fields
    # self.clock_in = parse and combine field_clock_in_date and _time
    # parse clock out times and set self.clock_out 
    self.clock_out += 1.day if self.clock_in > self.clock_out
  end

  # Custom attributes:

  def field_clock_in_date
    self.clock_in ? self.clock_in.strftime("%Y-%m-%d") : Time.zone.now.strftime("%Y-%m-%d")
  end

  def field_clock_in_time
    self.clock_in ? self.clock_in.strftime("%I:%M") : Time.zone.now.strftime("%I:%M")
  end

  def field_clock_out_date
    self.clock_out ? self.clock_out.strftime("%Y-%m-%d") : Time.zone.now.strftime("%Y-%m-%d")
  end

  def field_clock_out_time
    self.clock_out ? self.clock_out.strftime("%I:%M") : Time.zone.now.strftime("%I:%M")
  end

  
  # Length of workday 
  def duration
    self.clock_out - self.clock_in  
  end
  
  # Length of workday, in hours rounded to the nearest decimal place.
  def duration_hours(l=2)
   ( self.duration / 1.hour ).round(l)
  end
    
  # Allows viewing of deactivated users' timecards.
  def user
    User.unscoped{ super }
  end
end

