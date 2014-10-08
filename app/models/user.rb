require 'mongoid/multi_parameter_attributes'

class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::MultiParameterAttributes
  include IceCube
  
  field :name
  field :spotify_id
  field :spotify_playlist_id
  field :spotify_hash, type: Hash
  
  field :schedule, type: Hash
  before_save :set_schedule
  
  field :starts_at, type: Time
  validates :starts_at, presence: true
  
  field :ends_at, type: Time
  validate :ends_at_after_starts_at
  
  def schedule=(attr)
    self[:schedule] = attr.to_hash
  end
  
  def schedule
    Schedule.from_hash(self[:schedule])
  end
  
  protected
  
  def set_schedule
    unless self[:repeats] == 'none'
      schedule = Schedule.new(self[:starts_at], end_time: self[:ends_at])
      schedule.add_recurrence_rule Rule.daily
      # case self[:repeats]
      # when 'daily'
      #   schedule.add_recurrence_rule Rule.daily.until(self[:repeat_ends_on])
      # when 'weekly'
      #   schedule.add_recurrence_rule Rule.weekly.until(self[:repeat_ends_on])
      # when 'monthly'
      #   schedule.add_recurrence_rule Rule.monthly.until(self[:repeat_ends_on])
      # end
      self[:schedule] = schedule.to_hash
    end
  end
  
  def ends_at_after_starts_at
    if self[:starts_at] > self[:ends_at]
      errors.add(:ends_at, 'Endzeitpunkt ist vor dem Startzeitpunkt')
    end
  end
end