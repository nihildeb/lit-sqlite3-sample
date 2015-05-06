# lit-sqlite3-sample

Tests and Examples for SQLite lit package https://github.com/nihildeb/lit-sqlite3

A sample app using nihildeb/sqlite3 on lit.luvit.io

This works on 64-bit Linux 64-bit


```sh
curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh
./lit make github://nihildeb/lit-sqlite3-sample
./rainbows
```

## TODO:
- Windows support
- Linux ARM support
- OSX Support
- Coroutine support for queries

## Example code from main.lua

``` lua
local sql = require('sqlite3')

p('sqlite version:', sql.version())

-- open an in-memory database
local db = sql.open_memory()

-- you can also use a persistent disk based database of course
-- but then you would need to drop tables between runs, or delete the db file
-- local db = sql.open(db_file.db)

-- sql line comments work in heredoc type notation
local enable_fk = [[
  -- a sql comment
  PRAGMA foreign_keys = ON -- ; at the end of the line
  -- and in the middle of a statement
  ;
]]

-- exec will execute single statements, but doesn't return results
-- we don't actually use sqlite3's exec because C callbacks are slow in luajit
db:exec(enable_fk)

-- exec will also take a callback which is called for each result row
local pragma_fk = [[ PRAGMA foreign_keys; ]]
local assert_fk_on = function(row) assert(1 == row[1]) end
db:exec(pragma_fk, assert_fk_on)

-- create a table
local schema_entity = [[
  create table entity (
    id integer primary key autoincrement,
    name text
  );
]]
db:exec(schema_entity)

-- add a record
db:exec("insert into entity(name) values('scaredy bat');")
db:exec("insert into entity(name) values('misery');")

print() -- new line

-- get it back
-- p is a function provided by luvit/pretty-print
db:exec("select * from entity;", p) 

-- add another table
local schema_component = [[
  create table component (
    id integer primary key,
    key text not null,
    val text not null,
    entity_id int REFERENCES entity
  );
]]
db:exec(schema_component)

-- exec is just shorthand for :prepare(), :step(), :finalize()
-- longhand is definitely faster if you can reuse the prepared statement
-- it also might be prefered if you don't like messing with callbacks
local insert_component = [[
  insert into component(key, val, entity_id)
    values (?,?,?);
]]
local stmt = db:prepare(insert_component)

-- callback to initialize the in_hand component
local init_component = function(row) 
  -- bind component key, initial value, entity id
  stmt:bind_values('in_hand', '', row[1])

  -- :step() returns true if there are more result rows on a query
  -- and returns false when the statement is complete without error
  assert(false == stmt:step())

  -- a statement must be :reset() before we call bind again
  stmt:reset()
end

-- for each entity, like map
db:exec("select id from entity", init_component)

-- finalize or leak
stmt:finalize()

-- configure component for an entity
local config_component = [[
  -- no update joins in sqlite :(
  -- also this needs indexes, but it's just an example
  update component set val = ?
    where 
      component.key = 'in_hand'
      AND
      entity_id in (select id from entity where entity.name = ?)
]]
stmt = db:prepare(config_component)

stmt:bind_values('lightning rod', 'misery')
assert(false == stmt:step())
stmt:reset()

stmt:bind_values('bag of mosquitos', 'scaredy bat')
assert(false == stmt:step())
stmt:finalize()

-- and finally example of a system query which might use this
-- Entity/Component 
local in_hand_system = [[
  select e.name, c.val
  from entity e join component c on e.id = c.entity_id;
]]

print() -- new line
db:exec(in_hand_system, function(row)
  print(row[1]..' is holding a '..row[2])
end)
print() -- new line
```
