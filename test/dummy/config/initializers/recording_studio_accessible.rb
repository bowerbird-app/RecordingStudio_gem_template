# frozen_string_literal: true

RecordingStudioAccessible.configure do |config|
  config.access_actor_types = [ "User" ]

  # Required. An unset scope raises instead of listing every user.
  config.access_management_actor_scope = ->(_controller) { User.order(:email) }
end
