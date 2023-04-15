class ApplicationController < ActionController::Base
  def google_drive_service
    Rails.application.config.google_drive
  end
  helper_method :google_drive_service
end
