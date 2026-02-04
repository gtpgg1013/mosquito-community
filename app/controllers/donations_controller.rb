class DonationsController < ApplicationController
  def index
    @total_donated = Donation.total_donated
    @total_this_year = Donation.total_this_year
    @donations = Donation.by_recent.limit(10)
    @monthly_totals = Donation.monthly_totals
    @by_organization = Donation.by_organization
    @donation_count = Donation.count
  end
end
