lu = require('luaunit')
require('TestCompat')
require("LibStub")

TestAccessors = {}

function TestAccessors:test_accessors()
    for major, library in LibStub:IterateLibraries() do
        -- check that MyLib doesn't exist yet, by iterating through all the libraries
        lu.assertNotEquals(major, "MyLib")
    end

    lu.assertNil(LibStub:GetLibrary("MyLib", true)) -- check that MyLib doesn't exist yet by direct checking
    lu.assertFalse(pcall(LibStub.GetLibrary, LibStub, "MyLib")) -- don't silently fail, thus it should raise an error.
    local lib = LibStub:NewLibrary("MyLib", 1) -- create the lib
    lu.assertIsTable(lib) -- check it exists
    lu.assertIs(LibStub:GetLibrary("MyLib"), lib) -- verify that :GetLibrary("MyLib") properly equals the lib reference

    lu.assertIsTable(LibStub:NewLibrary("MyLib", 2))    -- create a new version

    local count = 0
    for major, library in LibStub:IterateLibraries() do
        -- check that MyLib exists somewhere in the libraries, by iterating through all the libraries
        if major == "MyLib" then
            -- we found it!
            count = count + 1
            lu.assertIs(library, lib) -- verify that the references are equal
        end
    end
    lu.assertEquals(count, 1) -- verify that we actually found it, and only once
end

--
-- Run the tests
--

os.exit(lu.run())
