class Company < ApplicationRecord
  SLUG_FORMAT = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/
  SUPPORTED_CURRENCIES = %w[BRL].freeze

  normalizes :name, :timezone, with: ->(value) { value.strip }
  normalizes :legal_name, :document, with: ->(value) { value.strip.presence }
  normalizes :slug, with: ->(value) { value.strip.downcase }
  normalizes :currency, with: ->(value) { value.strip.upcase }

  validates :name, :slug, :timezone, :currency, presence: true
  validates :slug, format: { with: SLUG_FORMAT }, uniqueness: { case_sensitive: false }
  validates :currency, inclusion: { in: SUPPORTED_CURRENCIES }
  validates :cash_difference_tolerance_cents,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :active, inclusion: { in: [ true, false ] }
  validate :timezone_must_be_iana_identifier

  private

  def timezone_must_be_iana_identifier
    return if timezone.blank?

    TZInfo::Timezone.get(timezone)
  rescue TZInfo::InvalidTimezoneIdentifier
    errors.add(:timezone, :invalid)
  end
end
