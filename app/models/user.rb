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
  field :activated, type: Boolean, default: true
  
  field :schedule, type: Hash
  before_save :set_schedule
  
  field :starts_at, type: Time
  validates :starts_at, presence: true, on: :update
  
  field :ends_at, type: Time
  validate :ends_at_after_starts_at, on: :update
  
  field :weekend, type: Boolean, default: true
  
  def schedule=(attr)
    self[:schedule] = attr.to_hash
  end
  
  def schedule
    Schedule.from_hash(self[:schedule])
  end
  
  protected
  
  def set_schedule
    schedule = Schedule.new(self[:starts_at], end_time: self[:ends_at])
    schedule.add_recurrence_rule Rule.weekly.day(:monday, :tuesday, :wednesday, :thursday, :friday)
    schedule.add_recurrence_rule Rule.weekly.day(:saturday, :sunday) if self[:weekend]
    self[:schedule] = schedule.to_hash
  end
  
  def ends_at_after_starts_at
    if self[:starts_at] > self[:ends_at]
      errors.add(:ends_at, 'Endzeitpunkt ist vor dem Startzeitpunkt')
    end
  end
end