@lags =
  order: (start, duration, price) -> {start, duration, price}

  profit: (orders) -> switch
    when orders.length == 0 then 0
    else orders[0].price
