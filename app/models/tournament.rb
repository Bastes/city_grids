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
  validates :places,             numericality: { only_integer: true, greater_than: 0 },
                                 allow_blank: true

  scope :alive,     -> { where deleted: false }
  scope :incoming,  -> { where 'begins_at > ?', Date.today }
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

  def ends_at_date
    I18n.l ends_at, format: '%Y-%m-%d' if ends_at?
  end

  def ends_at_time
    I18n.l ends_at, format: '%H:%M' if ends_at?
  end

  def copy_errors_for_begins_at_and_ends_at
    %i(begins_at ends_at).each do |field|
      if errors[field]
        errors[field].each do |error|
          errors.add :"#{field}_date", error
          errors.add :"#{field}_time", error
        end
      end
    end
  end

  def to_param
    "#{id}--#{begins_at.to_date.to_param}--#{name.gsub(/<[^>]+>/, '').parameterize}"
  end
end
