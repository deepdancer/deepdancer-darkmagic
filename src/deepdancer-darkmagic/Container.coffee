recursiveReadDir = require 'readdir-recursive'
Promise = require 'bluebird'

OriginalContainer = require 'deepdancer/Container'
Definition = require 'deepdancer-darkmagic/Definition'

isASourceFile = (path) ->
  if path.indexOf('.js') == path.length - 3
    return true
  if path.indexOf('.coffee') == path.length - 7
    return true
  false

removeExtension = (path) ->
  parts = path.split('.')
  parts.pop()
  parts.join('.')


getModuleFromPath = (path) ->
  path = removeExtension(path)
  toRemove = '/index'
  if path.indexOf(toRemove) == path.length - toRemove.length
    parts = path.split(toRemove)
    parts.pop()
    path = parts.join(toRemove)
  path


class Container extends OriginalContainer

  register: (args...) =>
    definition = new Definition(args...)
    key = args[0]
    @_definitions[key] = definition


  registerAliasByRootPath: (rootPath, rootModule, ignore = []) =>
    if !rootModule?
      rootModule = rootPath

    filesPath = recursiveReadDir.fileSync(rootPath)
    for path in filesPath
      @_registerAliasByRootPath(path, rootPath, rootModule, ignore)


  _registerAliasByRootPath: (path, rootPath, rootModule, ignore) =>
    if !isASourceFile(path)
      # nothing to do
      return
    actualModuleName = getModuleFromPath(path.replace(rootPath, rootModule))
    aliasName = actualModuleName.split('/').pop()
    if !@_shouldRegisterAliasByRootPath(actualModuleName, ignore)
      return

    if @has(aliasName)
      throw new Error('Tried to register ' + aliasName + ' as an alias for ' +
        actualModuleName + ' but something is already registered under this '+
        'name in the container.')
    @register(aliasName, actualModuleName, type: 'alias')


  _shouldRegisterAliasByRootPath: (actualModuleName, ignore) =>
    if actualModuleName in ignore
      return false
    for pattern in ignore
      if typeof pattern == 'string'
        continue #already tested above
      # It's an RE not just a string
      if pattern.test(actualModuleName)
        return false
    return true




module.exports = Container
