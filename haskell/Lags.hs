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
landing o = takeOff o + duration o

data Plan = Plan { ordersByLanding :: Map Timestamp [Order]
                 , lastTime :: Timestamp}
            deriving Show

profit :: [Order] -> Money
profit [] = 0
profit os = profitAt (lastTime p)
    where p = plan os
          profitAt :: Timestamp -> Money
          profitAt = memoize $ \t -> case Map.lookup t (ordersByLanding p) of
              Nothing -> 0
              Just os -> maximum $ map profitFor os
          profitFor :: Order -> Money
          profitFor o = (price o) + (profitAt $ takeOff o)

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
    where extractTakeOffAndLanding = uncurry (++) ^<< extractTakeOff &&& extractLanding
          extractTakeOff = map takeOff
          extractLanding = map landing
          sortDesc = sortBy (flip compare)
          nubSorted = map head . group

makeFakeOrders :: [Timestamp] -> [Order]
makeFakeOrders = map makeFakeOrder . pairWithNext
    where pairWithNext = uncurry zip ^<< tail &&& id
          makeFakeOrder(t, l) = Order t (l - t) 0

groupOrdersByLanding :: [Order] -> Map Timestamp [Order]
groupOrdersByLanding =  Map.fromList . prependLandingTime . groupByLanding . sortByLanding
    where sortByLanding = sortBy (compare `on` landing)
          groupByLanding = groupBy ((==) `on` landing)
          prependLandingTime = map $ landing . head &&& id
