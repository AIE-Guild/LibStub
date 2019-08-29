--
-- These functions adapt or mock Lua extensions in the WoW API.
--

function date(...)
    return os.date(...)
end

function strmatch(...)
    return string.match(...)
end
