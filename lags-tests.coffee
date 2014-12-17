{expect} = chai
{profit, order, key_times} = lags

sample = [
  order 0, 5, 10
  order 3, 7, 14
  order 5, 9, 7
  order 6, 9, 8
]

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

  it.skip "is the sum of the prices of 2 consecutive orders", ->
    (expect profit [
      order 0, 5, 10
      order 5, 5, 17
    ]).to.equal 27

describe "key_times", ->
  it "is the list of take off and landing times", ->
    times = key_times sample
    (expect times).to.deep.equal [0, 3, 5, 6, 10, 14, 15]
