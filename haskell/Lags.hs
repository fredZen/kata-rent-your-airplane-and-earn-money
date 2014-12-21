module Lags where

import Data.List

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
profit [] = 0
profit os = maxProfit
    where p = plan os
          maxProfit = case p of
              [os] -> (maximum . map price) os
              [[o], [o']] -> (price o) + (price o')

plan :: [Order] -> Plan
plan = groupBy sameLanding

sameLanding :: Order -> Order -> Bool
sameLanding o o' = (landing o) == (landing o')
