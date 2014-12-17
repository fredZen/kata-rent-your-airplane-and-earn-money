@lags =
  order: (start, duration, price) -> {start, duration, price}

  profit: (orders) -> switch orders.length
    when 0 then 0
    when 1 then orders[0].price
    when 2 then Math.max orders[0].price, orders[1].price
