#!/usr/bin/tarantool

assert(_TARANTOOL, "you may run this example only using Tarantool >= 1.6: https://tarantool.org")

local http = require 'http.client'
local json = require 'json'
local yaml = require 'yaml'
local log  = require 'log'


local Google = require 'oauth2' {
	-- Server specific params:
	authorization_uri = "https://accounts.google.com/o/oauth2/v2/auth",
	response_type = "code",
	exchange_uri = "https://www.googleapis.com/oauth2/v4/token",
	refresh_uri = "https://www.googleapis.com/oauth2/v4/token",

	-- Client specific params:
	client_id = "<client-id>",
	client_secret = "<client-secret>",
	redirect_uri = "http://localhost", -- real redirect uri

	-- Application specific params:
	scope = "https://www.googleapis.com/auth/drive.readonly",
	access_type = "offline",
	grant_type = "authorization_code",
}

--- Step 1. Resirect user to authorization prompt:
local url = Google:authorize {
	state = "<csrf-token>",
}

---> redirect user to url
print(url)

--- Step 2. If user allows access to his data we receive authorization_code in `code` variable
-- This code we must exchange for `refresh` and `access` tokens:
-- theese params will be returned by Google for us via user redirect:
local params = {
	code = "<authorization-code>",
	state = "<csrf-token>",
	scope = "<accepted-scope>",
}

-- Step 2.1 Validate csrf-token in `params.state` and accepted scope in `params.scope`
-- Build request to Google to exchange given code with token:
local request = Google:exchange {
	code = params.code,
}

local response = http.post(request.uri, request.body)
-- Validate http status:
if response.status == 200 then
	if response.headers["content-type"] == "application/json" then
		local credentials = json.decode(response.body)
		log.info("Credentials: %s", yaml.encode(credentials))
	end
end

