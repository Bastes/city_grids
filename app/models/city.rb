class City < ActiveRecord::Base
  has_many :tournaments
  has_many :incoming_tournaments, -> { incoming }, class_name: 'Tournament'

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
