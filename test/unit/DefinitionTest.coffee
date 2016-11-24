{expect} = require 'chai'

Definition = require 'deepdancer-darkmagic/Definition'

describe 'deepdancer-darkmagic/Definition', ->

  it 'should load dependencies name from function arguments', ->
    sampleFunction = (john1, paul42, smith12) -> 'returning is useless'

    definition = new Definition('sampleFunction', sampleFunction,
      type: 'factory'
    )

    expect(definition.dependencies.length).to.be.equal 3
    expect(definition.dependencies).to.contain 'paul42'


  it 'should load partial dependencies from a dictionnary', ->
    sampleFunction = (john1, paul42, smith12) -> 'returning is useless'

    definition = new Definition('sampleFunction', sampleFunction,
      type: 'factory'
      dependencies:
        john1: 'mary57'
    )

    expect(definition.dependencies.length).to.be.equal 3
    expect(definition.dependencies).to.contain 'paul42'
    expect(definition.dependencies).to.not.contain 'john1'
    expect(definition.dependencies[0]).to.equal 'mary57'
