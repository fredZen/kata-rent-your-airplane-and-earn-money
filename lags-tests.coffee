{expect} = chai
{aux_profit, by_landing_time, key_times, order, profit} = lags

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

  it "is the sum of the prices of 2 consecutive orders", ->
    (expect profit [
      order 0, 5, 10
      order 5, 9, 7
    ]).to.equal 17

  it "works with a full example", ->
    (expect profit sample).to.equal 18

describe "aux_profit", ->
  it "is the max profit so far when there are no more points in time to examine", ->
    (expect aux_profit 15, [], {}).to.equal 15

  it "is the max profit so far when there are no orders for the point in time to examine", ->
    (expect aux_profit 15, [0], {}).to.equal 15

  it "is profit of the order because it is bigger than the max profit so far", ->
    (expect aux_profit 0, [5], {5: [order 0, 5, 10]}).to.equal 10

  it "sums price of the flight with profits for connecting flights so far", ->
    (expect aux_profit 10, [14], {14: [order 5, 9, 7]}, {5: 10}).to.equal 17

  it "sums price of two flights", ->
    (expect aux_profit 10, [5, 14],
      5: order 0, 5, 10
      14: [order 5, 9, 7]
    ).to.equal 17

describe "key_times", ->
  it "is the list of take off and landing times", ->
    (expect key_times sample).to.deep.equal [0, 3, 5, 6, 10, 14, 15]

describe "by_landing_time", ->
  it "is the lis of orders grouped by landing time", ->
    (expect by_landing_time sample).to.deep.equal
      5: [order 0, 5, 10]
      10: [order 3, 7, 14]
      14: [order 5, 9, 7]
      15: [order 6, 9, 8]
