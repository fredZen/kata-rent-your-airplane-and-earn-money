{key_times, landing_time, by_landing_time, previous_times} = @order

profit = (orders) ->
  profits_up_to = _.memoize (time) ->
    switch previous[time]
      when undefined then 0
      else
        best_landing = _(orders_by_landing_time[time]).map(({start, price}) ->
            price + profits_up_to start
          ).max().value()
        Math.max(best_landing, profits_up_to previous[time])

  times = key_times orders
  last = _.last times
  previous = previous_times times
  orders_by_landing_time = by_landing_time orders
  profits_up_to last

@lags ||= {}
@lags.memo = {profit}
