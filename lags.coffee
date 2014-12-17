order = (start, duration, price) -> {start, duration, price}

landing_time = ({start, duration}) -> start + duration

profit = (orders) ->
  times = key_times orders
  orders_by_landing_time = by_landing_time orders
  switch orders.length
    when 0 then 0
    when 1 then orders[0].price
    when 2 then Math.max orders[0].price, orders[1].price

aux_profit = (max_profits, times, orders_by_landing_time) ->
  switch times.length
    when 0 then max_profits
    else
      time = _.head(times)
      landing_profit = _(orders_by_landing_time[time]).map('price').max()
      Math.max(max_profits, landing_profit)

key_times = (orders) ->
  takeoff_times = _.pluck orders, 'start'
  landing_times = _.map orders, landing_time
  _.sortBy(_.union(takeoff_times, landing_times))

by_landing_time = (orders) ->
  _.groupBy orders, landing_time

@lags = {aux_profit, by_landing_time, key_times, order, profit}
