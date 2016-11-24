OriginalDefinition = require 'deepdancer/Definition'

STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg
ARGUMENT_NAMES = /([^\s,]+)/g
getParametersNames = (func) ->
  fnStr = func.toString().replace(STRIP_COMMENTS, '')
  sliced = fnStr.slice(fnStr.indexOf('(') + 1, fnStr.indexOf(')'))
  result = sliced.match(ARGUMENT_NAMES)
  if !result?
    result = []
  result


class Definition extends OriginalDefinition

  _extractFromModule: =>
    super
    if @dependencies.length > 0
      return

    dependenciesInferenceKey = '__dependenciesInference'
    if dependenciesInferenceKey in @value && !@value[dependenciesInferenceKey]
      return

    if !@type in ['factory', 'class']
      return

    parameters = @_inferParameters(@dependencies)

    @dependencies = parameters


  _inferParameters: (potentialDependenciesMap) =>
    parametersNames = getParametersNames(@value)
    potentialDependenciesMapKeys = Object.keys(potentialDependenciesMap)
    parameters = []

    for parameterName in parametersNames
      if parameterName in potentialDependenciesMapKeys
        parameters.push potentialDependenciesMap[parameterName]
      else
        parameters.push parameterName

    parameters


module.exports = Definition