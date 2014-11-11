-- for errors
local inspect = require('lib.inspect')

local compile

local function compile_explist(input)
  local list = {}
  for i, v in ipairs(input) do
    table.insert(list, compile({v}))
  end
  return table.concat(list, ",")
end

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
    local lua = "function(" .. compile_explist(args) .. ")\n"
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
    s = s .. compile_explist(node[3])
    s = s .. ")"
    return s
  end;

  ret = function(node)
    return "return " .. compile_explist(node[2])
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
