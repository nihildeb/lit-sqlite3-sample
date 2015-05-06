local assrt = require('assrt')

require('tap')(function(test)

  test('has a version', function()
    local sql = require('sqlite3')
    assrt.eq('3.8.9', sql.version())
  end)

  test('opens a memory db', function()
    local sql = require('sqlite3')
    local mem = sql.open_memory()
    assrt.typ('table', mem)
    assrt.typ('cdata', mem.db)
  end)

  test('opens a file db', function()
    local fs = require('fs')
    local test_db_name = 'test.db'
    assrt.eq(false, fs.existsSync(test_db_name))

    local sql = require('sqlite3')
    local db = sql.open(test_db_name)
    assrt.typ('table', db)
    assrt.typ('cdata', db.db)
    assrt.eq(true, fs.existsSync(test_db_name))
    os.remove(test_db_name)
  end)

  test('complete() recognizes a complete stmt', function()
    local sql = require('sqlite3')
    local good_stmt = "select date('now');"
    local bad_stmt =  "select date('now')"
    assrt.eq(true, sql.complete(good_stmt))
    assrt.eq(false, sql.complete(bad_stmt))
  end)

end)


