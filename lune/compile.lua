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

  string = function(node)
    return "'" .. node[2] .. "'";
  end;

  dot = function(node)
    assert(node[3][1] == "identifier")
    lua = compile({node[2]}) .. "." .. node[3][2]
    return lua
  end;

  func = function(node)
    local _, args, body = unpack(node)
    local arguments = {}
    for i, v in ipairs(args) do
      assert(v[1] == "identifier")
      table.insert(arguments, v[2])
    end

    local lua = "function(" .. table.concat(arguments, ",") .. ")\n"
    if #body > 0 then
      lua = lua .. "return " .. compile({body}) .. "\n"
    end
    lua = lua .. "end\n"
    return lua
  end;

  table = function(node)
    return "{}"
  end;

  call = function(node)
    local s = ""
    s = s .. compile({node[2]})
    s = s .. "("
    local arguments = {}
    for i,v in ipairs(node[3]) do
      local argument = compile({v})
      table.insert(arguments, argument)
    end
    s = s .. table.concat(arguments, ",")
    s = s .. ")"
    return s
  end;

  ret = function(node)
    local list = {}
    for i, v in ipairs(node[2]) do
      table.insert(list, compile({v}))
    end
    return "return " .. table.concat(list, ",")
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
