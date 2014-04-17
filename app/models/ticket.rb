class Ticket < ActiveRecord::Base
  STATUS_VALUES = %w(pending present forfeit)

  belongs_to :tournament

  validates :tournament, presence: true
  validates :nickname,   presence: true, uniqueness: {scope: :tournament_id}
  validates :email,      presence: true, uniqueness: {scope: :tournament_id}, email: true
  validates :status,     presence: true, inclusion: {in: STATUS_VALUES}

  scope :present, -> { where(status: 'present') }

  before_save :set_admin

  def initialize *args, &block
    super
    self.status ||= 'pending'
  end

  def set_admin
    self.admin ||= Digest::MD5.new.update("#{nickname}#{Time.now}").to_s
  end
end
