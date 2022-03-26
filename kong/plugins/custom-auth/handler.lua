local http = require "resty.http"

local TokenHandler = {
    VERSION = "1.0",
    PRIORITY = 1000,
}

local function validate_access_token(conf, access_token)
    local httpc = http:new()

    local res, err = httpc:request_uri(conf.authentication_endpoint, {
        method = "POST",
        ssl_verify = false,
        headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. access_token }
    })

    if not res then
        kong.log.err("failed to call introspection endpoint: ", err)
        return kong.response.exit(500)
    end
    if res.status ~= 200 then
        kong.log.err("introspection endpoint responded with status: ", res.status)
        return kong.response.exit(res.status)
    end

    return true -- all is well
end

function TokenHandler:access(conf)
    local access_token = kong.request.get_headers()[conf.token_header]
    if not access_token then
        kong.response.exit(403)  --unauthorized
    end
    -- replace Bearer prefix
    access_token = access_token:sub(8, -1) -- drop "Bearer "

    validate_access_token(conf, access_token)
end

return TokenHandler