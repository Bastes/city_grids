class Ticket < ActiveRecord::Base
  belongs_to :tournament

  validates :tournament, presence: true
  validates :nickname,   presence: true, uniqueness: {scope: :tournament_id}
  validates :email,      presence: true, uniqueness: {scope: :tournament_id}, email: true
end
