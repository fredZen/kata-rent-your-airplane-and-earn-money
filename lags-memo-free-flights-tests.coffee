{expect} = @chai
{order, free_flights} = @order
{profit} = @lags.memo_free_flights

sample = [
  order 0, 5, 10
  order 3, 7, 14
  order 5, 9, 7
  order 6, 9, 8
]

describe "Memoized lags with free flights inserted", ->
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

    it "is the sum of the prices of 2 consecutive orders", ->
      (expect profit [
        order 0, 5, 10
        order 5, 9, 7
      ]).to.equal 17

    it "prefer taking a flight that profits more than one that lands later", ->
      (expect profit [
        order 0, 3, 10
        order 0, 5, 7
      ]).to.equal 10

  describe "free_flights", ->
    it "generates zero-price flights between consecutive times", ->
      (expect free_flights [1, 4, 8, 10]).to.deep.equal [
        order 1, 3, 0
        order 4, 4, 0
        order 8, 2, 0
      ]
