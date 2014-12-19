order = (start, duration, price) -> {start, duration, price}

by_landing_time = (orders) ->
  _.groupBy orders, landing_time

landing_time = ({start, duration}) -> start + duration

key_times = (orders) ->
  takeoff_times = _.pluck orders, 'start'
  landing_times = _.map orders, landing_time
  _.sortBy(_.union(takeoff_times, landing_times))

previous_times = (times) ->
  _(times).tail().zipObject(times).value()

@order = {order, landing_time, key_times, previous_times, by_landing_time}
