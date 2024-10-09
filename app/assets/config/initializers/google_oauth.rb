require 'googleauth'

SCOPE = ['https://www.googleapis.com/auth/cloud-platform'].freeze

def get_google_oauth_token
  authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
    json_key_io: File.open('path_to_your_service_account_json_file.json'), # サービスアカウントのJSONファイルのパス
    scope: SCOPE
  )
  authorizer.fetch_access_token!['access_token']
end
