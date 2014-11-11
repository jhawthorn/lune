lune={}
lune.parse=require('lune.parse')
lune.compile_ast=require('lune.compile')
lune.compile=function(string)
return lune.compile_ast(lune.parse(string))
end

lune.loadstring=function(string)
return loadstring(lune.compile(string))
end

lune.eval=function(string)
return lune.loadstring(string)()
end

return lune