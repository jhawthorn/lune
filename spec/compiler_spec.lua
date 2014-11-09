local compile = require('lune.compile')

describe("Compiler", function()
  it("can compile number", function()
    local lua = compile({{"number", "42"}})
    assert.are.equal("42", lua)
  end)

  describe("string", function()
    it("can compile empty", function()
      local lua = compile({{"string", ""}})
      assert.are.same("''", lua)
    end)

    it("can compile simple", function()
      local lua = compile({{"string", "123"}})
      assert.are.same("'123'", lua)
    end)
  end)

  describe("function", function()
    it("can compile with no body", function()
      local lua = compile({{"func", {}, {}}})
      assert.are.same("function()\nend\n", lua)
    end)

    it("can compile function", function()
      local lua = compile({{"func", {}, {"number", "123"}}})
      assert.are.same("function()\nreturn 123\nend\n", lua)
    end)

    it("can compile function with argument", function()
      local lua = compile({{"func", {{"identifier", "val"}}, {"number", "123"}}})
      assert.are.same("function(val)\nreturn 123\nend\n", lua)
    end)

    it("can compile function with two arguments", function()
      local lua = compile({{"func", {{"identifier", "a"}, {"identifier", "b"}}, {"number", "123"}}})
      assert.are.same("function(a,b)\nreturn 123\nend\n", lua)
    end)
  end)

  describe("function call", function()
    it("can compile with no arguments", function()
      local lua = compile({{"call", {"identifier", "print"}}})
      assert.are.same("print()", lua)
    end)

    it("can compile with one argument", function()
      local lua = compile({{"call", {"identifier", "print"}, {"number", "123"}}})
      assert.are.same("print(123)", lua)
    end)

    it("can compile with two arguments", function()
      local lua = compile({{"call", {"identifier", "print"}, {"number", "123"}, {"number", "456"}}})
      assert.are.same("print(123,456)", lua)
    end)
  end)

  describe("table", function()
    it("can compile empty table", function()
      local lua = compile({{"table", {}}})
      assert.are.same("{}", lua)
    end)
  end)
end)
