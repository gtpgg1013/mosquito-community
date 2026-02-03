# Clerk configuration
# Get your keys from https://dashboard.clerk.com

require "clerk"

Clerk.configure do |config|
  config.secret_key = ENV.fetch("CLERK_SECRET_KEY", nil)
  config.publishable_key = ENV.fetch("CLERK_PUBLISHABLE_KEY", nil)
end
