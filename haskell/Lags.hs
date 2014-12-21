module Lags where

type Timestamp = Int
type Duration = Int
type Money = Int

data Order = Order { takeOff :: Timestamp
                   , duration :: Duration
                   , price :: Money }

landing :: Order -> Timestamp
landing o = takeOff o + duration o

type Plan = [[Order]]

profit :: [Order] -> Money
profit os = maxProfit
    where p = plan os
          maxProfit = case p of
              [] -> 0
              [os] -> (maximum . map price) os
              [[o], [o']] -> (price o) + (price o')

plan :: [Order] -> Plan
plan [] = []
plan [o] = [[o]]
plan [o, o']
    | (landing o == landing o') = [[o, o']]
    | otherwise = [[o], [o']]
