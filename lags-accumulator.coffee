{by_landing_time, key_times} = @order

profit = (orders) ->
  times = key_times orders
  orders_by_landing_time = by_landing_time orders
  aux_profit 0, times, orders_by_landing_time

aux_profit = (max_profits, times, orders_by_landing_time, profits_by_time={}) ->
  switch times.length
    when 0 then max_profits
    else
      time = _.head(times)
      landing_profit = _(orders_by_landing_time[time]).map(cumulative_profit(profits_by_time)).max()
      max_profits = Math.max(max_profits, landing_profit)
      profits_by_time[time] = max_profits
      aux_profit(max_profits, _.tail(times), orders_by_landing_time, profits_by_time)

cumulative_profit = (profits_by_time) -> ({start, price}) ->
  profit_so_far = profits_by_time[start] || 0
  price + profit_so_far

@lags ||= {}
@lags.accumulator = {aux_profit, profit}
