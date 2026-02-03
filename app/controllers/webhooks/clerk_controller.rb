module Webhooks
  class ClerkController < ApplicationController
    # Allow frontend sync requests with CSRF token
    skip_before_action :verify_authenticity_token, only: [:create], if: :official_webhook?

    def create
      payload = request.body.read
      event = JSON.parse(payload)

      case event["type"]
      when "user.created"
        handle_user_created(event["data"])
      when "user.updated"
        handle_user_updated(event["data"])
      when "user.deleted"
        handle_user_deleted(event["data"])
      end

      head :ok
    rescue JSON::ParserError => e
      Rails.logger.error "Clerk webhook JSON parse error: #{e.message}"
      head :bad_request
    rescue => e
      Rails.logger.error "Clerk webhook error: #{e.message}"
      head :internal_server_error
    end

    private

    def official_webhook?
      request.headers["svix-id"].present?
    end

    def handle_user_created(data)
      # Handle both official webhook format and frontend sync format
      clerk_id = data["id"]
      email = data.dig("email_addresses", 0, "email_address") || data["primaryEmailAddress"]&.dig("emailAddress")
      first_name = data["first_name"] || data["firstName"]
      last_name = data["last_name"] || data["lastName"]
      avatar_url = data["image_url"] || data["imageUrl"]

      user = User.find_or_initialize_by(clerk_user_id: clerk_id)
      user.assign_attributes(
        email: email,
        display_name: [first_name, last_name].compact.join(" ").presence,
        avatar_url: avatar_url
      )

      if user.new_record?
        user.save!
        Rails.logger.info "Created user from Clerk: #{clerk_id}"
      elsif user.changed?
        user.save!
        Rails.logger.info "Updated user from Clerk: #{clerk_id}"
      end
    end

    def handle_user_updated(data)
      user = User.find_by(clerk_user_id: data["id"])
      return unless user

      user.update(
        email: data.dig("email_addresses", 0, "email_address"),
        display_name: [data["first_name"], data["last_name"]].compact.join(" ").presence,
        avatar_url: data["image_url"]
      )
      Rails.logger.info "Updated user from Clerk: #{data['id']}"
    end

    def handle_user_deleted(data)
      user = User.find_by(clerk_user_id: data["id"])
      user&.destroy
      Rails.logger.info "Deleted user from Clerk: #{data['id']}"
    end
  end
end
