order = (start, duration, price) -> {start, duration, price}

profit = (orders) ->
  times = key_times orders
  switch orders.length
    when 0 then 0
    when 1 then orders[0].price
    when 2 then Math.max orders[0].price, orders[1].price

key_times = (orders) ->
  takeoff_times = _.pluck orders, 'start'
  landing_times = _.map orders, (o) -> o.start + o.duration
  _.sortBy(_.union(takeoff_times, landing_times))

by_landing_time = (orders) ->
  _.groupBy orders, ({start, duration}) -> start + duration

@lags = {order, profit, key_times, by_landing_time}
