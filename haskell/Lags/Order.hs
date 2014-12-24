module Lags.Order where

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

type Problem = [Order]

landing :: Order -> Timestamp
landing = compose (+) takeOff duration

compose :: (b -> b' -> c) -> (a -> b) -> (a -> b') -> (a -> c)
compose f g h = uncurry f ^<< g &&& h

data Plan = Plan { ordersByLanding :: Map Timestamp [Order]
                 , times :: [Timestamp] }

plan :: Problem -> Plan
plan os = Plan (groupOrdersByLanding $ os ++ (makeFakeOrders times)) $ times
    where times = extractTimes os

extractTimes :: Problem -> [Timestamp]
extractTimes =
        compose (++) (map takeOff) (map landing) >>>
        sortBy (flip compare) >>>
        group >>> map head

makeFakeOrders :: [Timestamp] -> [Order]
makeFakeOrders = map makeFakeOrder . pairWithNext
    where pairWithNext = compose zip tail id
          makeFakeOrder(t, l) = Order t (l - t) 0

groupOrdersByLanding :: [Order] -> Map Timestamp [Order]
groupOrdersByLanding =
        sortBy (compare `on` landing) >>>
        groupBy ((==) `on` landing) >>>
        (map $ compose (,) (landing . head) id) >>>
        Map.fromList
