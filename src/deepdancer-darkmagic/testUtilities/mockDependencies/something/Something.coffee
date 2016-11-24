class Something

  constructor: (@sayer) -> 'Nothing to do here'

  sayHello: =>
    @sayer('Something')



Something.__type = 'class'
Something.__dependencies = ['sayer']


module.exports = Something