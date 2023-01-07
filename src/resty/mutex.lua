local semaphore = require 'ngx.semaphore'

---@class resty.mutex
---@field sem ngx.semaphore
local _M = {}
local _mt = { __index = _M }

function _M.new()
    local sem, err = semaphore.new(1)
    if not sem then
        return nil, err
    end
    return setmetatable({ sem }, _mt)
end

function _M:lock(timeout)
    return self.sem:wait(timeout)
end

function _M:unlock()
    self.sem:post(1)
end

function _M:locked(timeout, f, ...)
    local ok, err = self:lock(timeout)
    if not ok then
        return nil, err
    end

    local ret = { pcall(f, ...) }
    self:unlock()
    if not ret[0] then
        return nil, ret[1]
    end
    return unpack(ret, 1)
end

return _M
