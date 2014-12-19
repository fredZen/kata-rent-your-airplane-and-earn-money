{expect} = @chai
{order, previous_times} = @order
{profit} = @lags.memo

sample = [
  order 0, 5, 10
  order 3, 7, 14
  order 5, 9, 7
  order 6, 9, 8
]

describe "Memoized lags", ->
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

  describe "previous time", ->
    it "matches a time to the previous time in the list", ->
      (expect previous_times [1,4,7,10]).to.deep.equal(
        4: 1
        7: 4
        10: 7
      )
