local parse = require('lune.parse')

assert:set_parameter("TableFormatLevel", -1)

describe("Parser", function()
  it("can parse number", function()
    local ast = parse("42")
    assert.are.same({{"number", "42"}}, ast)
  end)

  describe("assignment", function()
    it("can parse simple assignment", function()
      local ast = parse("foo = 123")
      assert.are.same({{"assignment", {{"identifier", "foo"}}, {{"number", "123"}}}}, ast)
    end)

    it("can parse dot assignment", function()
      local ast = parse("foo.bar = 123")
      assert.are.same({{"assignment", {{"dot", {"identifier", "foo"}, {"identifier", "bar"}}}, {{"number", "123"}}}}, ast)
    end)
  end)

  describe("dot", function()
    it("can parse dot", function()
      local ast = parse("foo.bar")
      assert.are.same({{"dot", {"identifier", "foo"}, {"identifier", "bar"}}}, ast)
    end)
  end)

  describe("return", function()
    it("can return void", function()
      local ast = parse("return")
      assert.are.same({{"ret", {}}}, ast)
    end)

    it("can return immediate", function()
      local ast = parse("return 123")
      assert.are.same({{"ret", {{"number", "123"}}}}, ast)
    end)
  end)

  describe("function", function()
    it("can parse empty function", function()
      local ast = parse("->")
      assert.are.same({{"func", {}, {}}}, ast)
    end)

    it("can parse function", function()
      local ast = parse("-> 123")
      assert.are.same({{"func", {}, {"number", "123"}}}, ast)
    end)

    it("can parse function empty arguments", function()
      local ast = parse("() -> 123")
      assert.are.same({{"func", {}, {"number", "123"}}}, ast)
    end)

    it("can parse function with argument", function()
      local ast = parse("(val) -> 123")
      assert.are.same({{"func", {{"identifier", "val"}}, {"number", "123"}}}, ast)
    end)

    it("can parse function with multiple arguments", function()
      local ast = parse("(a, b) -> 123")
      assert.are.same({{"func", {{"identifier", "a"}, {"identifier", "b"}}, {"number", "123"}}}, ast)
    end)
  end)

  describe("table", function()
    it("can parse empty table", function()
      local ast = parse("{}")
      assert.are.same({{"table", {}}}, ast)
    end)
  end)

  describe("double quote string", function()
    it("can parse empty string", function()
      local ast = parse('""')
      assert.are.same({{"string", ""}}, ast)
    end)

    it("can parse simple string", function()
      local ast = parse('"123"')
      assert.are.same({{"string", "123"}}, ast)
    end)
  end)

  describe("single quote string", function()
    it("can parse empty string", function()
      local ast = parse("''")
      assert.are.same({{"string", ""}}, ast)
    end)

    it("can parse simple string", function()
      local ast = parse("'123'")
      assert.are.same({{"string", "123"}}, ast)
    end)
  end)

  describe("call", function()
    it("can parse without arguments", function()
      local ast = parse("foo()")
      assert.are.same({{"call", {"identifier", "foo"}, {}}}, ast)
    end)

    it("can parse with one argument", function()
      local ast = parse("foo(123)")
      assert.are.same({{"call", {"identifier", "foo"}, {{"number", "123"}}}}, ast)
    end)

    it("can parse with whitespace around argument", function()
      local ast = parse("foo(  123  )")
      assert.are.same({{"call", {"identifier", "foo"}, {{"number", "123"}}}}, ast)
    end)

    it("can parse two arguments", function()
      local ast = parse("foo(1, 2)")
      assert.are.same({{"call", {"identifier", "foo"}, {{"number", "1"}, {"number", "2"}}}}, ast)
    end)

    it("can parse three arguments", function()
      local ast = parse("foo(1 , 2 , 3)")
      assert.are.same({{"call", {"identifier", "foo"}, {{"number", "1"}, {"number", "2"}, {"number", "3"}}}}, ast)
    end)

    it("can parse calling the result of a call", function()
      local ast = parse("foo(123)(456)")
      assert.are.same({{"call", {"call", {"identifier", "foo"}, {{"number", "123"}}}, {{"number", "456"}}}}, ast)
    end)
  end)
end)

