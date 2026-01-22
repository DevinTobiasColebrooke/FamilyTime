class ApplicationController < ActionController::Base
  include Pagy::Method
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_user
  before_action :authenticate_user!

  private

  def set_current_user
    if session[:user_id]
      Current.user = User.find_by(id: session[:user_id])
    end
  end

  def authenticate_user!
    redirect_to sign_in_path, alert: "You must be signed in to access this page." unless Current.user
  end
end
