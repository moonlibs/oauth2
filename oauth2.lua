local M = {}

local url = require 'net.url'

--- OAuth2 credentials
-- Client credentials:
-- + client_id (public)
-- + redirect_uri (public)
-- + client_secret (private)

local function new(args)
	return setmetatable({
		-- Client params:
		client_id     = assert(args.client_id, "client_id is required"),
		client_secret = assert(args.client_secret, "client_secret is required"),
		redirect_uri  = assert(args.redirect_uri, "redirect_uri is required"),

		-- authorization specific params:
		authorization_uri = url.parse(assert(args.authorization_uri, "authorization_uri is required")),
		response_type = args.response_type or "code",
		scope = args.scope,

		-- exchange specific params:
		exchange_uri = url.parse(assert(args.exchange_uri, "exchange_uri is required")),
		grant_type = args.grant_type or "authorization_code",

		refresh_uri = args.refresh_uri and url.parse(assert(args.refresh_uri, "refresh_uri is required")),
	}, {
		__index = M,
	})
end

-- Step 1. Construct authorization url to authenticate
-- our application for Authorization Server

function M:authorize(args)
	self.authorization_uri:setQuery {
		client_id     = self.client_id,
		redirect_uri  = self.redirect_uri,
		response_type = assert(args.response_type or self.response_type, "response_type is required"), -- must not be nil

		access_type   = self.access_type, -- can be nil for Dropbox
		scope         = args.scope or self.scope, -- can be nil for Dropbox
		state         = args.state, -- can be nil
	}
	return tostring(self.authorization_uri)
end

-- Step 2. Provide mechanism to get refresh_token using authorization_code
function M:exchange(args)
	return {
		uri = tostring(self.exchange_uri),
		body = url.buildQuery {
			code = assert(args.code, "code is required"),
			client_id = self.client_id,
			client_secret = self.client_secret,
			redirect_uri = self.redirect_uri,
			grant_type = self.grant_type,
		},
	}
end

-- Step 3. Refresh access_token
function M:refresh(args)
	self.refresh_uri:setQuery {
		client_id = self.client_id,
		client_secret = self.client_secret,
		refresh_token = assert(args.refresh_token, "refresh_token is required"),
		grant_type = "refresh_token"
	}
	return tostring(self.refresh_uri)
end

return setmetatable(M, { __call = function(_, ...) return new(...) end })
