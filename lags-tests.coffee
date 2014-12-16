{expect} = chai
{profit} = lags

describe "profit", ->
  it "is 0 when there are no orders", ->
    (expect profit []).to.equal 0
