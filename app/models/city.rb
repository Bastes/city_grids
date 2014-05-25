class City < ActiveRecord::Base
  has_many :tournaments, dependent: :destroy
  has_many :incoming_tournaments, -> { alive.incoming.activated.ordered }, class_name: 'Tournament'

  validates :name,  presence: true
  validates :email, presence: true, email: true

  scope :activated, -> { where(activated: true) }

  before_save :set_admin

  def set_admin
    self.admin ||= Digest::MD5.new.update("#{name}#{Time.now}").to_s
  end

  def self.find_by_name name
    self.where('name ILIKE ?', name).first
  end

  def to_param
    "#{id}-#{name.gsub(/<[^>]+>/, '')}".parameterize
  end
end
