module Lags where

import Control.Arrow
import Data.Function
import Data.List
import Data.Map

type Timestamp = Int
type Duration = Int
type Money = Int

data Order = Order { takeOff :: Timestamp
                   , duration :: Duration
                   , price :: Money }

landing :: Order -> Timestamp
landing o = takeOff o + duration o

data Plan = Plan { ordersByLanding :: Map Timestamp [Order]
                 , lastTime :: Timestamp}

profit :: [Order] -> Money
profit [] = 0
profit os = profitAt (lastTime p)
    where p = plan os
          profitAt :: Timestamp -> Money
          profitAt t = case Data.Map.lookup t (ordersByLanding p) of
              Nothing -> 0
              Just os -> maximum $ Data.List.map profitFor os
          profitFor :: Order -> Money
          profitFor o = (price o) + (profitAt $ takeOff o)

plan :: [Order] -> Plan
plan os = Plan byLanding lastTime
    where times = Data.List.map head $ group $ sortBy (flip compare) $ (Data.List.map takeOff os) ++ (Data.List.map landing os)
          byLanding = fromList $ Data.List.map (landing . head &&& id) $ groupBy sameLanding os
          lastTime = head times

sameLanding :: Order -> Order -> Bool
sameLanding = ( == ) `on` landing
