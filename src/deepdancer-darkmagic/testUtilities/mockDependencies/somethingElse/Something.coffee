class Something

  constructor: (@sayer) -> 'Nothing to do here'

  sayHello: =>
    @sayer('Something but in somethingElse')



Something.__type = 'class'
Something.__dependencies = ['sayer']


module.exports = Something