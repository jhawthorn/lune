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

  describe("call", function()
    it("can parse without arguments", function()
      local ast = parse("foo()")
      assert.are.same({{"call", {"identifier", "foo"}}}, ast)
    end)

    it("can parse with one argument", function()
      local ast = parse("foo(123)")
      assert.are.same({{"call", {"identifier", "foo"}, {"number", "123"}}}, ast)
    end)

    it("can parse with whitespace around argument", function()
      local ast = parse("foo(  123  )")
      assert.are.same({{"call", {"identifier", "foo"}, {"number", "123"}}}, ast)
    end)

    it("can parse two arguments", function()
      local ast = parse("foo(1, 2)")
      assert.are.same({{"call", {"identifier", "foo"}, {"number", "1"}, {"number", "2"}}}, ast)
    end)

    it("can parse three arguments", function()
      local ast = parse("foo(1 , 2 , 3)")
      assert.are.same({{"call", {"identifier", "foo"}, {"number", "1"}, {"number", "2"}, {"number", "3"}}}, ast)
    end)

    it("can parse calling the result of a call", function()
      --local ast = parse("foo(123)(456)")
      return pending()
    end)
  end)
end)

