module Lags where

type Timestamp = Int
type Duration = Int
type Money = Int

data Order = Order { takeOff :: Timestamp
                   , duration :: Duration
                   , price :: Money }

type Plan = [Order]

profit :: [Order] -> Money
profit os = maxProfit
    where p = plan os
          maxProfit = case p of
              [] -> 0
              os -> (maximum . map price) os

plan :: [Order] -> Plan
plan = id
