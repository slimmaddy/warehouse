require 'google/apis/drive_v3'

GoogleDrive = Google::Apis::DriveV3
Google::Apis.logger.level = Logger::ERROR

Rails.application.config.google_drive = GoogleDrive::DriveService.new
Rails.application.config.google_drive.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open(Rails.root.join('config/google_credentials.json')),
  scope: GoogleDrive::AUTH_DRIVE
)
