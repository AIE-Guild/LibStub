--
-- These functions adapt or mock Lua extensions in the WoW API.
--

function debugstack(...)
    return debug.traceback(...)
end

function strmatch(...)
    return string.match(...)
end
