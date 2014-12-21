module Lags where

import Data.List
import Data.Function

type Timestamp = Int
type Duration = Int
type Money = Int

data Order = Order { takeOff :: Timestamp
                   , duration :: Duration
                   , price :: Money }

landing :: Order -> Timestamp
landing o = takeOff o + duration o

data Plan = Plan {orders :: [[Order]] }

profit :: [Order] -> Money
profit [] = 0
profit os = maxProfit
    where p = plan os
          maxProfit = case orders p of
              [os] -> (maximum . map price) os
              [[o], [o']] -> (price o) + (price o')

plan :: [Order] -> Plan
plan = Plan . groupBy sameLanding

sameLanding :: Order -> Order -> Bool
sameLanding = ( == ) `on` landing
