package = 'construct'
version = '0.2-0'
description = {
  summary = 'Data structures.',
  detailed = [[
    A collection of robust and extensible data structures,
    implemented in pure Lua.
  ]],
  homepage = 'http://struct.oka.io',
  maintainer = 'yo@oka.io',
  license = 'MIT'
}
source = {
	url = 'git://github.com/Okahyphen/construct',
	tag = 'v0.2.0'
}
dependencies = {
  'lua >= 5.1',
  'base >= 2.0'
}
build = {
  type = 'builtin',
  modules = {
    ['construct'] = 'src/construct.lua',

    ['construct.Collection'] = 'src/Collection.lua',
    ['construct.DataSet']    = 'src/DataSet.lua',
    ['construct.List']       = 'src/List.lua',
    ['construct.Map']        = 'src/Map.lua',
    ['construct.Queue']      = 'src/Queue.lua',
    ['construct.Stack']      = 'src/Stack.lua',
    ['construct.Tuple']      = 'src/Tuple.lua',
    ['construct.WeakMap']    = 'src/WeakMap.lua'
  }
}
