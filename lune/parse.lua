
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

local function nest_chain(base, chain)
  for i,v in ipairs(chain) do
    table.insert(v, 2, base)
    base = v
  end
  return base
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

  statement = V"ret" + V"assignment" + V"expression";

  assignment = Ct(V"assignable") * space * P"=" * space * Ct(V"expression") / emit("assignment");
  assignable = V"chain" + V"identifier";

  expression = space * V"value" * space;
  explist = (Ct(space * V"value" * (space * P"," * space * V"value")^0) + Ct"") * space;

  simplevalue = V"number" + V"string" + V"identifier" + V"func" + V"table";
  value = V"chain" + V"simplevalue";
  chain = (V"simplevalue" * Ct((V"chaincall" + V"chaindot")^1)) / nest_chain;
  chaindot = P"." * V"identifier" / emit("dot");
  chaincall = P"(" * V"explist" * P")" / emit("call");

  number = R"09"^1 / emit("number");

  table = P"{" * Ct("") * "}" / emit("table");

  string = V"singlestring" + V"doublestring";
  singlestring = P"'" * C((1 - P"'")^0) * P"'" / emit("string");
  doublestring = P'"' * C((1 - P'"')^0) * P'"' / emit("string");

  identifier = (R("az", "AZ", "__") * alphanum^0) / emit"identifier";

  func = Ct(V"fnargs") * P"->" * space * (V"statement" + Ct"") / emit"func";
  fnargs = P"(" * space * V"namelist"^-1 * P")"* space + P"";
  namelist = V"identifier" * space * (P"," * space * V"identifier" * space)^0;

  call = V"value" * P"()";

  ret = P"return" * space * V"explist" / emit("ret");
}

local function parse(input)
  local ret = tokens:match(input)
  if not ret then
    error("couldn't compile input \"" .. input .. "\"")
  end
  return ret
end

return parse
