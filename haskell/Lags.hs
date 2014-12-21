module Lags where

type Timestamp = Int
type Duration = Int
type Money = Int

data Order = Order { takeOff :: Timestamp
                   , duration :: Duration
                   , price :: Money }

profit :: [Order] -> Money
profit [] = 0
profit [o] = price o
