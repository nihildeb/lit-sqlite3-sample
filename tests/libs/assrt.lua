exports.name = "nihildeb/assrt"
exports.version = "0.1.0"

assrt = {}

function print_message (expected, actual, message, default_message)
  print(msg or default_message)
  print "expected:"
  p(expected)
  print "actual:"
  p(actual)
end

assrt.equal = function(expected, actual, message)
  if(expected == actual) then return true end
  print_message(expected, actual, message, "NOT EQUAL")
  assert(expected == actual)
  error('assrt lib failure')
end
assrt.eq = assrt.equal

assrt.lengthOf = function(expected, actual, message)
  local count = 0
  for _ in pairs(actual) do count = count + 1 end

  if(expected == count) then return true end
  print_message(expected, count, message, "BAD LENGTH")
  assert(expected == count)
  error('assrt lib failure')
end
assrt.len = assrt.lengthOf

assrt.typeOf = function(expected, actual, message)
  if(expected == type(actual)) then return true end
  print_message(expected, type(actual), message, "BAD TYPE")
  assert(expected == type(actual))
  error('assrt lib failure')
end
assrt.typ = assrt.typeOf

return assrt
