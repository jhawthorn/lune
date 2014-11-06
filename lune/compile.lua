
local compile
local compilers = {
  assignment = function(token)
    _, lhs, rhs = unpack(token)
    lua = ''
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
    return "function()\nreturn " .. compile({token[2]}) .. "\nend\n"
  end;
}

compile = function(tokens)
  local lua = ""
  for i,token in ipairs(tokens) do
    compiler = compilers[token[1]]
    if not compiler then
      error("No compiler defined for " .. token[1])
    end
    val = compiler(token)
    if not val then
      error("Error: couldn't compile " .. inspect(token))
    end
    lua = lua .. val
  end
  return lua
end

return compile
