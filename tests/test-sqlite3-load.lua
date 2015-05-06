local assrt = require('assrt')

require('tap')(function(test)
  test('sqlite ffi loads', function()
    local ffi = require('ffi')
    local sql = require('sqlite3')
    assrt.typ('table',sql)
    assrt.typ('function',sql.version)
  end)
end)

