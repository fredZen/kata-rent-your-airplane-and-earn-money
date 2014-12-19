{key_times, by_landing_time, free_flights} = @order

profit = (orders) ->
  profits_up_to = _.memoize (time) ->
    arrivals = orders_by_landing_time[time]
    switch arrivals
      when undefined then 0
      else
        _(arrivals).map(({start, price}) ->
          price + profits_up_to start
        ).max().value()

  times = key_times orders
  extra_flights = free_flights times
  orders_by_landing_time = by_landing_time orders.concat extra_flights
  profits_up_to _.last times

@lags ||= {}
@lags.memo_free_flights = {profit}
