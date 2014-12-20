{key_times, by_landing_time, free_flights} = @order

profit = (orders) ->
  profits_up_to = _.memoize (time) ->
    arrivals = plan.orders_by_landing_time[time]
    switch arrivals
      when undefined then 0
      else
        _(arrivals).map(({start, price}) ->
          price + profits_up_to start
        ).max().value()

  plan = make_plan orders
  profits_up_to plan.last_time

make_plan = (orders) ->
  times = key_times orders
  extra_flights = free_flights times
  orders_by_landing_time = by_landing_time orders.concat extra_flights
  {orders_by_landing_time, last_time: _.last times}

@lags ||= {}
@lags.memo_free_flights = {profit}
