# Clerk authentication concern
# Handles JWT verification and user session management
module ClerkAuthenticatable
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :user_signed_in?
  end

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to root_path, alert: "Please sign in to continue."
    end
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = nil

    # Get session token from cookie (set by Clerk JS)
    session_token = cookies["__session"]

    # Debug logging
    Rails.logger.info "=== CLERK AUTH DEBUG ==="
    Rails.logger.info "All cookies: #{cookies.to_h.keys.join(', ')}"
    Rails.logger.info "__session cookie present: #{session_token.present?}"
    Rails.logger.info "__session value (first 50 chars): #{session_token&.first(50)}"

    return nil unless session_token

    begin
      # Verify JWT with Clerk
      payload = Clerk::SDK.new.verify_token(session_token)
      clerk_user_id = payload["sub"]
      Rails.logger.info "Clerk user ID from token: #{clerk_user_id}"

      @current_user = User.find_by(clerk_user_id: clerk_user_id)
      Rails.logger.info "User found: #{@current_user&.id}"
    rescue => e
      Rails.logger.error "Clerk auth error: #{e.message}"
      Rails.logger.error e.backtrace.first(5).join("\n")
      nil
    end
  end

  def user_signed_in?
    current_user.present?
  end
end
