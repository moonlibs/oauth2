local Dropbox = require 'oauth2' {
	authorization_uri = "https://www.dropbox.com/1/oauth2/authorize",
	exchange_uri = "https://api.dropbox.com/1/oauth2/token",
	-- Dropbox does not have refresh_uri.
	-- Instead application may use access_token as long as it wants to.

	-- Application specific params:
	client_id = "<client-id>",
	client_secret = "<client-secret>",
	redirect_uri = "http://localhost",

	grant_type = "authorization_code",
}
