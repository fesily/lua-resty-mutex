# lua-resty-mutex

In-process critical area, base on ngx.semaphore

## How to use

```lua
local mutex = require 'resty.mutex'
local mtx = mutex.new()
mtx:lock()
--other code
mtx:unlock()
```
