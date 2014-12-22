module Lags where

import Control.Arrow
import Data.Function
import Data.List
import Data.Map (Map)
import qualified Data.Map as Map

type Timestamp = Int
type Duration = Int
type Money = Int

data Order = Order { takeOff :: Timestamp
                   , duration :: Duration
                   , price :: Money }
             deriving (Eq, Show)

landing :: Order -> Timestamp
landing = compose (+) takeOff duration

compose :: (b -> b' -> c) -> (a -> b) -> (a -> b') -> (a -> c)
compose f g h = uncurry f ^<< g &&& h

data Plan = Plan { ordersByLanding :: Map Timestamp [Order]
                 , lastTime :: Timestamp}

profit :: [Order] -> Money
profit [] = 0
profit os = profitAt (lastTime p)
    where p = plan os
          profitAt = memoize $ maybe 0 maxProfit . ordersLandingAt
          ordersLandingAt = flip Map.lookup $ ordersByLanding p
          maxProfit = maximum . map profitFor
          profitFor = compose (+) price $ profitAt . takeOff

memoize :: (Int -> a) -> (Int -> a)
memoize f = (map f [0 ..] !!)

plan :: [Order] -> Plan
plan os = Plan byLanding lastTime
    where times = extractTimes os
          lastTime = head times
          fakeFlights = makeFakeOrders times
          byLanding = groupOrdersByLanding $ os ++ fakeFlights

extractTimes :: [Order] -> [Timestamp]
extractTimes = nubSorted . sortDesc . extractTakeOffAndLanding
    where extractTakeOffAndLanding = compose (++) extractTakeOff extractLanding
          extractTakeOff = map takeOff
          extractLanding = map landing
          sortDesc = sortBy (flip compare)
          nubSorted = map head . group

makeFakeOrders :: [Timestamp] -> [Order]
makeFakeOrders = map makeFakeOrder . pairWithNext
    where pairWithNext = compose zip tail id
          makeFakeOrder(t, l) = Order t (l - t) 0

groupOrdersByLanding :: [Order] -> Map Timestamp [Order]
groupOrdersByLanding =  Map.fromList . prependLandingTime . groupByLanding . sortByLanding
    where sortByLanding = sortBy (compare `on` landing)
          groupByLanding = groupBy ((==) `on` landing)
          prependLandingTime = map $ compose (,) (landing . head) id
