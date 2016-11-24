class DarkMagiced

  constructor: (@sayer) -> 'Nothing to do here'

  sayHello: =>
    @sayer('DarkMagiced')



DarkMagiced.__type = 'class'


module.exports = DarkMagiced