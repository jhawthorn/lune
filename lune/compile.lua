-- for errors
local inspect = require('lib.inspect')

local compile
local compilers = {
  assignment = function(token)
    local _, lhs, rhs = unpack(token)
    local lua = ''
    for i=1,#lhs do
      lua = lua .. compile({lhs[i]}) .. "=" .. compile({rhs[i]}) .. "\n"
    end
    return lua
  end;

  identifier = function(token)
    return token[2]
  end;

  number = function(token)
    return token[2]
  end;

  func = function(token)
    if #token[2] == 0 then
      return "function()\nend\n"
    else
      return "function()\nreturn " .. compile({token[2]}) .. "\nend\n"
    end
  end;

  call = function(node)
    local s = ""
    s = s .. compile({node[2]})
    s = s .. "("
    local arguments = {}
    for i = 3,#node do
      local argument = compile({node[i]})
      table.insert(arguments, argument)
    end
    s = s .. table.concat(arguments, ",")
    s = s .. ")"
    return s
  end;

}

compile = function(tokens)
  local lua = ""
  for i,token in ipairs(tokens) do
    local compiler = compilers[token[1]]
    if not compiler then
      error("No compiler defined for " .. inspect(token))
    end
    local val = compiler(token)
    if not val then
      error("Error: couldn't compile " .. inspect(token))
    end
    lua = lua .. val
  end
  return lua
end

return compile
