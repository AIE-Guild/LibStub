lu = require('luaunit')
require('TestCompat')
require("LibStub")

TestProxy = {}

function TestProxy:test_proxy()
    local proxy = newproxy() -- non-string

    lu.assertFalse(pcall(LibStub.NewLibrary, LibStub, proxy, 1)) -- should error, proxy is not a string, it's userdata
    local success, ret = pcall(LibStub.GetLibrary, proxy, true)
    lu.assertTrue(not success or not ret) -- either error because proxy is not a string or because it's not actually registered.

    lu.assertFalse(pcall(LibStub.NewLibrary, LibStub, "Something", "No number in here")) -- should error, minor has no string in it.

    lu.assertNil(LibStub:GetLibrary("Something", true)) -- shouldn't've created it from the above statement
end

--
-- Run the tests
--

os.exit(lu.run())
