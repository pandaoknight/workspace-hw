-- script.lua
counter = 1
requests = {}

function init(args)
    local file_path = "base64_encoded_images.txt"
    for line in io.lines(file_path) do
        requests[counter] = line
        counter = counter + 1
    end
end

function request()
    local body = requests[math.random(#requests)]
    local headers = {}
    headers["Content-Type"] = "application/json"
    return wrk.format("POST", nil, headers, body)
end
