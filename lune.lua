
-- some global helpers
inspect = require('lib.inspect')
function p(...)
  print(inspect(...))
end

local lune = {
  parse = require('lune.parse');
  compile_ast = require('lune.compile');
  compile = function(string)
    return lune.compile_ast(lune.parse(string))
  end;
  loadstring = function(string)
    return loadstring(lune.compile(string))
  end;
  eval = function(string)
    lune.loadstring(string)()
  end
}

return lune
