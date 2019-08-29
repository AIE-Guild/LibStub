lu = require('luaunit')
require('TestCompat')
require("LibStub")

lib, oldMinor = LibStub:NewLibrary("Pants", 1) -- make a new thingy

TestNewLibrary = {}

function TestNewLibrary:test_new()
    lu.assertIsTable(lib) -- should return the library table
    lu.assertNil(oldMinor) -- should not return the old minor, since it didn't exist
end

function TestNewLibrary:test_version()
    -- the following is to create data and then be able to check if the same data exists after the fact
    function lib:MyMethod()
    end
    local MyMethod = lib.MyMethod
    lib.MyTable = {}
    local MyTable = lib.MyTable

    local newLib, newOldMinor = LibStub:NewLibrary("Pants", 1) -- try to register a library with the same version, should silently fail
    lu.assertNil(newLib) -- should not return since out of date

    local newLib, newOldMinor = LibStub:NewLibrary("Pants", 0) -- try to register a library with a previous, should silently fail
    lu.assertNil(newLib) -- should not return since out of date

    local newLib, newOldMinor = LibStub:NewLibrary("Pants", 2) -- register a new version
    lu.assertIsTable(newLib) -- library table
    lu.assertIs(newLib, lib) -- should be the same reference as the previous
    lu.assertEquals(newOldMinor, 1) -- should return the minor version of the previous version

    lu.assertIs(lib.MyMethod, MyMethod) -- verify that values were saved
    lu.assertIs(lib.MyTable, MyTable) -- verify that values were saved

    local newLib, newOldMinor = LibStub:NewLibrary("Pants", "Blah 3 Blah") -- register a new version with a string minor version (instead of a number)
    lu.assertIsTable(newLib) -- library table
    lu.assertEquals(newOldMinor, 2) -- previous version was 2

    local newLib, newOldMinor = LibStub:NewLibrary("Pants", "Blah 4 and please ignore 15 Blah") -- register a new version with a string minor version (instead of a number)
    lu.assertIsTable(newLib)
    lu.assertEquals(newOldMinor, 3) -- previous version was 3 (even though it gave a string)

    local newLib, newOldMinor = LibStub:NewLibrary("Pants", 5) -- register a new library, using a normal number instead of a string
    lu.assertIsTable(newLib)
    lu.assertEquals(newOldMinor, 4) -- previous version was 4 (even though it gave a string)
end


--
-- Run the tests
--

os.exit(lu.run())
