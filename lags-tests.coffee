{expect} = chai
{profit, order} = lags

describe "profit", ->
  it "is 0 when there are no orders", ->
    (expect profit []).to.equal 0

  it "is the price of the order when there is only 1", ->
    (expect profit [order 0, 5, 10]).to.equal 10
