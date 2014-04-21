class Tournament < ActiveRecord::Base
  belongs_to :city
  has_many :tickets, dependent: :destroy
  has_many :present_tickets, -> { present }, class_name: 'Ticket'

  validates :city,               presence: true
  validates :organizer_nickname, presence: true
  validates :organizer_email,    presence: true, email: true
  validates :name,               presence: true
  validates :address,            presence: true
  validates :begins_at,          presence: true
  validates :ends_at,            timing: { after: :begins_at }, allow_blank: true

  scope :incoming,  -> { where 'begins_at > ?', Time.now.to_date }
  scope :activated, -> { where activated: true }
  scope :ordered,   -> { order 'begins_at asc' }

  before_save :set_admin
  after_validation :copy_errors_for_begins_at_and_ends_at

  def set_admin
    self.admin ||= Digest::MD5.new.update("#{name}#{Time.now}").to_s
  end

  def begins_at_date
    I18n.l begins_at, format: '%Y-%m-%d' if begins_at?
  end

  def begins_at_time
    I18n.l begins_at, format: '%H:%M' if begins_at?
  end

  def ends_at_time
    I18n.l ends_at, format: '%H:%M' if ends_at?
  end

  def copy_errors_for_begins_at_and_ends_at
    if errors[:begins_at]
      errors[:begins_at].each do |error|
        errors.add :begins_at_date, error
        errors.add :begins_at_time, error
      end
    end
    if errors[:ends_at]
      errors[:ends_at].each do |error|
        errors.add :ends_at_time, error
      end
    end
  end

  def to_param
    "#{id}--#{begins_at.to_date.to_param}--#{name.gsub(/<[^>]+>/, '').parameterize}"
  end
end
