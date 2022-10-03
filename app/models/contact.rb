class Contact < ApplicationRecord
  EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP # email regex are never perfect

  validate :website_url_is_valid?
  validates_presence_of :email, :first_name, :last_name, :company
  validates_length_of :email, :first_name, :last_name, :company, :website, maximum: 150
  validates_format_of :email, with: EMAIL_FORMAT
  validates :email, uniqueness: true

  has_many :contacts_events
  has_many :events, through: :contacts_events, class_name: 'Event'

  def website_url_is_valid?
    return unless website.present?
    return if validate_url_format?(website)

    errors.add(:website, :url_format_invalid)
  end

  def validate_url_format?(url)
    url = URI.parse(url) rescue false
    url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
  end

  def attributes
    {
      'email' => email,
      'first_name' => first_name,
      'last_name' => last_name,
      'company' => company,
      'website' => website,
      'events' => events.pluck(:name),
      'created_at' => created_at.strftime('%Y-%m-%d'),
      'updated_at' => updated_at.strftime('%Y-%m-%d')
    }
  end
end
