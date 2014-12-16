{expect} = chai

describe "Unit test", ->
  it "can fail", ->
    (expect 2).to.equal 1
  it "can pass", ->
    (expect 2).to.equal 2
