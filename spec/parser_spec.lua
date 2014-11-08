local parse = require('lune.parse')

describe("Parser", function()
  it("can parse number", function()
    local ast = parse("42")
    assert.are.same({{"number", "42"}}, ast)
  end)

  it("can parse function", function()
    local ast = parse("-> 123")
    assert.are.same({{"func", {"number", "123"}}}, ast)
  end)
end)

