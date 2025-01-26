---@class cjson
local cjson = {}

--- Translate a Lua value to a JSON string.
---@param value any @The Lua value to encode.
---@return string text @The resulting JSON string.
function cjson.encode(value) end

--- Decode a JSON string into a Lua value.
---@param text string @The JSON string to decode.
---@return any value @The resulting Lua value.
function cjson.decode(text) end

--- Creates a new independent cjson instance.
---@return cjson @The new cjson instance.
function cjson.new() end

--- Decode invalid numbers (e.g., NaN, Infinity) configuration.
---@param setting? boolean @Optional. Set to true to enable, false to disable.
---@return boolean setting @The current setting for decoding invalid numbers.
function cjson.decode_invalid_numbers(setting) end

--- Encode invalid numbers (e.g., NaN, Infinity) configuration.
---@param setting? boolean @Optional. Set to true to enable, false to disable.
---@return boolean setting @The current setting for encoding invalid numbers.
function cjson.encode_invalid_numbers(setting) end

--- Configure whether to keep the internal buffer used for encoding.
---@param keep? boolean @Optional. Set to true to keep, false to discard.
---@return boolean keep @The current setting for keeping the buffer.
function cjson.encode_keep_buffer(keep) end

--- Get or set the maximum encoding depth for nested tables.
---@param depth? number @Optional. The maximum depth to set.
---@return number depth @The current maximum encoding depth.
function cjson.encode_max_depth(depth) end

--- Get or set the maximum decoding depth for nested JSON objects.
---@param depth? number @Optional. The maximum depth to set.
---@return number depth @The current maximum decoding depth.
function cjson.decode_max_depth(depth) end

--- Configure sparse array encoding.
---@param convert? boolean @Optional. Set to true to convert sparse arrays to objects.
---@param ratio? number @Optional. The maximum ratio of holes to size.
---@param safe? boolean @Optional. Set to true to require safety in sparse array conversion.
---@return boolean convert, number ratio, boolean safe @The current settings for sparse array encoding.
function cjson.encode_sparse_array(convert, ratio, safe) end

--- A safe version of cjson for error handling.
---@class cjson_safe
local cjson_safe = {}

--- Same as cjson.encode but does not throw errors.
---@param value any @The Lua value to encode.
---@return string|nil text @The resulting JSON string, or nil if an error occurs.
function cjson_safe.encode(value) end

--- Same as cjson.decode but does not throw errors.
---@param text string @The JSON string to decode.
---@return any|nil value @The resulting Lua value, or nil if an error occurs.
function cjson_safe.decode(text) end

return cjson
