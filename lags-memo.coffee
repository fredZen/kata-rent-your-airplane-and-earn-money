{key_times, landing_time, by_landing_time, previous_times} = @order

profit = (orders) ->
  profits_up_to = _.memoize (time) ->
    switch previous[time]
      when undefined then 0
      else _(orders_by_landing_time[time]).pluck('price').max().value()

  times = key_times orders
  last = _.last times
  previous = previous_times times
  orders_by_landing_time = by_landing_time orders
  profits_up_to last

@lags ||= {}
@lags.memo = {profit}
