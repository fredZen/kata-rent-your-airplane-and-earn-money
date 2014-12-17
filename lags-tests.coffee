{expect} = chai
{profit, order} = lags

describe "profit", ->
  it "is 0 when there are no orders", ->
    (expect profit []).to.equal 0

  it "is the price of the order when there is only 1", ->
    (expect profit [order 0, 5, 10]).to.equal 10

  it "is the price of the biggest order when 2 orders overlap", ->
    (expect profit [
      order 0, 5, 10
      order 0, 5, 17
    ]).to.equal 17
