# Clerk configuration
# Get your keys from https://dashboard.clerk.com

require "clerk"

# Skip Clerk configuration if secret key is not present (e.g., in test/CI environment)
if ENV["CLERK_SECRET_KEY"].present?
  Clerk.configure do |config|
    config.secret_key = ENV["CLERK_SECRET_KEY"]
    config.publishable_key = ENV["CLERK_PUBLISHABLE_KEY"]
  end
elsif !Rails.env.production?
  Rails.logger.info "Clerk: Skipping configuration (no secret key found)"
else
  raise "CLERK_SECRET_KEY is required in production environment"
end
