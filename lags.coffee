order = (start, duration, price) -> {start, duration, price}

landing_time = ({start, duration}) -> start + duration

profit = (orders) ->
  times = key_times orders
  orders_by_landing_time = by_landing_time orders
  aux_profit 0, times, orders_by_landing_time

aux_profit = (max_profits, times, orders_by_landing_time, profits_by_time={}) ->
  switch times.length
    when 0 then max_profits
    else
      time = _.head(times)
      landing_profit = _(orders_by_landing_time[time]).map(({start, price}) ->
        profit_so_far = profits_by_time[start] || 0
        price + profit_so_far
      ).max()
      max_profits = Math.max(max_profits, landing_profit)
      profits_by_time[time] = max_profits
      aux_profit(max_profits, _.tail(times), orders_by_landing_time, profits_by_time)

key_times = (orders) ->
  takeoff_times = _.pluck orders, 'start'
  landing_times = _.map orders, landing_time
  _.sortBy(_.union(takeoff_times, landing_times))

by_landing_time = (orders) ->
  _.groupBy orders, landing_time

@lags = {aux_profit, by_landing_time, key_times, order, profit}
