class City < ActiveRecord::Base
  has_many :tournaments

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
