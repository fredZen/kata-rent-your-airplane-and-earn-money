module Lags.Fold where

import Data.Function
import Data.List
import Data.Map (Map, (!))
import qualified Data.Map as Map
import Lags.Order

profit :: Problem -> Money
profit [] = 0
profit os = (foldr (addProfit $ ordersByLanding p) Map.empty (times p)) ! (head (times p))
    where p = plan os

addProfit :: Map Timestamp [Order] -> Timestamp -> Map Timestamp Money -> Map Timestamp Money
addProfit ordersByLanding l profitByLanding = Map.insert l maxProfit profitByLanding
  where maxProfit = maybe 0 (maximum . map profitFor) $ Map.lookup l ordersByLanding
        profitFor = compose (+) price $ (profitByLanding !) . takeOff
