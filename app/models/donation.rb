class Donation < ApplicationRecord
  ORGANIZATIONS = [
    "Against Malaria Foundation",
    "Malaria Consortium",
    "Nothing But Nets",
    "WHO Malaria Program"
  ].freeze

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :organization, presence: true
  validates :donated_at, presence: true

  scope :by_recent, -> { order(donated_at: :desc) }
  scope :this_year, -> { where("donated_at >= ?", Time.current.beginning_of_year) }
  scope :by_month, ->(date) { where(donated_at: date.beginning_of_month..date.end_of_month) }

  def self.total_donated
    sum(:amount)
  end

  def self.total_this_year
    this_year.sum(:amount)
  end

  def self.monthly_totals(year = Time.current.year)
    where("EXTRACT(YEAR FROM donated_at) = ?", year)
      .group("EXTRACT(MONTH FROM donated_at)")
      .sum(:amount)
      .transform_keys(&:to_i)
  end

  def self.by_organization
    group(:organization).sum(:amount)
  end
end
