class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :authenticate_user!
  before_action :set_current_actor

  # Use a different layout for Devise controllers
  layout :layout_by_resource

  private

  def set_current_actor
    Current.actor = current_user
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "flat_pack_sidebar"
    end
  end
end
