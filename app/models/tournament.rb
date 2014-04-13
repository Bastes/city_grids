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

  before_save :set_admin

  def set_admin
    self.admin ||= Digest::MD5.new.update("#{name}#{Time.now}").to_s
  end
end
