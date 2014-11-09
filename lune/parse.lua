
local lpeg = require "lpeg"
lpeg.setmaxstack(10000)

local R, S, V, P = lpeg.R, lpeg.S, lpeg.V, lpeg.P
local C, Ct, Cmt = lpeg.C, lpeg.Ct, lpeg.Cmt
local match = lpeg.match
local locale = lpeg.locale()

local function count_indent(str)
  local sum = 0
  for v in str:gmatch("[\t ]") do
    if v == ' ' then sum = sum + 1 end
    if v == '\t' then sum = sum + 4 end
  end
  return sum
end

local function emit(name)
  return function(...)
    return {name, ...}
  end
end

local newline = P"\r"^-1 * P"\n";
local stop = newline + -1;
local space = S" \t"^0;

local indent = C(S"\t "^0) / count_indent;

local alphanum = R("az", "AZ", "09", "__");

local tokens = P {
  V"file";

  --check_indent = Cmt(indent, check_indent);

  file = Ct(V"line" * (newline^1 * V"line")^0) * space * -1;

  comment = P"#" * (1 - S"\r\n")^0 * #stop;

  line = (V"statement" + space) * V"comment"^-1 * #stop;

  statement = V"assignment" + V"expression";

  assignment = Ct(V"identifier") * space * P"=" * space * Ct(V"expression") / emit("assignment");

  expression = space * V"value" * space;
  explist = space * V"value" * (space * P"," * space * V"value")^0 * space;

  simplevalue = V"number" + V"identifier" + V"func";
  value = V"chain" + V"simplevalue";
  chain = V"simplevalue" * P"(" * V"explist"^-1 * P")" / emit("call");

  number = R"09"^1 / emit("number");

  identifier = (R("az", "AZ", "__") * alphanum^0) / emit"identifier";

  func = P"->" * space * (V"statement" + Ct"") / emit"func";

  call = V"value" * P"()";
}

local function parse(input)
  local ret = tokens:match(input)
  if not ret then
    error("couldn't compile input \"" .. input .. "\"")
  end
  return ret
end

return parse
