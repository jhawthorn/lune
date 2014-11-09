
-- some global helpers
inspect = require('lib.inspect')
function p(...)
  print(inspect(...))
end

local lune = {
  parse = require('lune.parse');
  compile_ast = require('lune.compile');
  compile = function(string)
    return lune.compile_ast(assert(lune.parse(string)))
  end;
  loadstring = function(string)
    return loadstring(assert(lune.compile(string)))
  end;
  eval = function(string)
    assert(lune.loadstring(string))()
  end
}

return lune
