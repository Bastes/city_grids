class Tournament < ActiveRecord::Base
  belongs_to :city

  validates :city,            presence: true
  validates :organizer_alias, presence: true
  validates :organizer_email, presence: true, email: true
  validates :name,            presence: true
  validates :address,         presence: true
  validates :begins_at,       presence: true
  validates :ends_at,         timing: { after: :begins_at }, allow_blank: true

  scope :incoming, -> { where('begins_at > ?', Time.now.to_date) }
  scope :ordered,  -> { order('begins_at asc') }
end
