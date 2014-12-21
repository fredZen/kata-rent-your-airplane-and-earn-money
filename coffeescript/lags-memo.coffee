{key_times, by_landing_time, previous_times} = @order

profit = (orders) ->
  profits_up_to = _.memoize (time) ->
    switch plan.previous[time]
      when undefined then 0
      else
        best_landing = _(plan.orders_by_landing_time[time]).map(({start, price}) ->
          price + profits_up_to start
        ).max().value()
        Math.max(best_landing, profits_up_to plan.previous[time])

  plan = make_plan orders
  profits_up_to plan.last_time

make_plan = (orders) ->
  times = key_times orders
  previous = previous_times times
  orders_by_landing_time = by_landing_time orders
  {orders_by_landing_time, previous, last_time: _.last times}

@lags ||= {}
@lags.memo = {profit}
