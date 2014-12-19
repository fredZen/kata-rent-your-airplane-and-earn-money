{key_times, landing_time, by_landing_time, previous_times} = @order

profit = (orders) ->
  times = key_times orders
  last = _.last times
  previous = previous_times times
  orders_by_landing_time = by_landing_time orders
  profits_up_to last, previous, orders_by_landing_time

profits_up_to = _.memoize (time, previous_times, orders) ->
  switch previous_times[time]
    when undefined then 0
    else orders[time][0].price

@lags ||= {}
@lags.memo = {profit}
