class Timecard < ApplicationRecord
  include ActiveModel::Validations
  
  # Relationships:
  belongs_to :user
  
  # Validations
  validates :description, length: {maximum: 100}
  validates :start, presence: true 
  validates :end, presence: true
  validates :user, presence: true
  validates_with TimecardValidator #Defined in concerns/timecard_validator.rb

  # Custom methods:
  
  def duration
    # Calculates length of workday, in hours rounded to the nearest decimal place.
   ((self.end - self.start) / 1.hour ).round(1)
  end

end
