class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_to(
      current_user ? request.referrer || root_path : new_user_session_path,
      alert: 'You are not authorized to perform this action.'
    )
  end
end
