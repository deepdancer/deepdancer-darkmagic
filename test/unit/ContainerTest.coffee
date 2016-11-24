{ expect } = require 'chai'

Container = require 'deepdancer-darkmagic/Container'

rootPath = 'src/deepdancer-darkmagic/testUtilities/mockDependencies'
rootModule = 'deepdancer-darkmagic/testUtilities/mockDependencies'

describe 'deepdancer-darkmagic/Container', ->

  it 'should correctly load aliases from a root path', ->
    container = new Container()
    container.setModulesAsAutoregistered(rootModule)
    ignore =
      ['deepdancer-darkmagic/testUtilities/mockDependencies' +
        '/somethingElse/Something']
    container.registerAliasByRootPath(rootPath, rootModule, ignore)
    helloSomething = container.get('Something').sayHello().toLowerCase()

    expect(helloSomething).to.contain 'hello something'
    expect(helloSomething).to.not.contain 'else'

    somethingElse = container.get('somethingElse').toLowerCase()
    expect(somethingElse).to.equal 'somethingelse index'


  it 'should fail on duplicated aliases', ->
    container = new Container()
    errorRaised = false
    try
      container.registerAliasByRootPath(rootPath, rootModule)
    catch
      errorRaised = true

    expect(errorRaised).to.be.true

    container = new Container()
    ignore =
      ['deepdancer-darkmagic/testUtilities/mockDependencies' +
        '/somethingElse/Something']

    errorRaised = false
    try
      container.registerAliasByRootPath(rootPath, rootModule, ignore)
    catch
      errorRaised = true

    expect(errorRaised).to.be.false


  it 'should load the dependencies from the parameters of the function', ->
    container = new Container()
    container.setModulesAsAutoregistered(rootModule)
    ignore =
      ['deepdancer-darkmagic/testUtilities/mockDependencies' +
        '/somethingElse/Something']
    container.registerAliasByRootPath(rootPath, rootModule, ignore)
    darkMagiced = container.get('DarkMagiced')
    said = darkMagiced.sayHello().toLowerCase()
    expect(said).to.contain 'hello darkmagiced'
