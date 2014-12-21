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
             deriving (Eq, Show)

landing :: Order -> Timestamp
landing o = takeOff o + duration o

data Plan = Plan { ordersByLanding :: Map Timestamp [Order]
                 , lastTime :: Timestamp}
            deriving Show

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
    where times = Data.List.map head $ group $ sortBy (flip compare) $ (Data.List.map takeOff os) ++ Data.List.map landing os
          lastTime = head times
          fakeFlights = makeFakeOrders times
          byLanding = groupOrdersByLanding $ os ++ fakeFlights

makeFakeOrders :: [Timestamp] -> [Order]
makeFakeOrders = Data.List.map makeFakeOrder . pairWithNext
    where pairWithNext = uncurry zip ^<< tail &&& id
          makeFakeOrder(t, l) = Order t (l - t) 0

groupOrdersByLanding :: [Order] -> Map Timestamp [Order]
groupOrdersByLanding =  fromList . prependLandingTime . groupByLanding . sortByLanding
    where sortByLanding = sortBy (compare `on` landing)
          groupByLanding = groupBy ((==) `on` landing)
          prependLandingTime = Data.List.map $ landing . head &&& id
