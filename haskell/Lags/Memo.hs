module Lags.Memo where

import Control.Arrow
import Data.Function
import Data.List
import Data.Map (Map)
import qualified Data.Map as Map
import Lags.Order

profit :: Problem -> Money
profit [] = 0
profit os = profitAt (head $ times p)
    where p = plan os
          profitAt = memoize $
              (flip Map.lookup $ ordersByLanding p) >>>
              maybe 0 (maximum . map profitFor)
          profitFor = compose (+) price $ profitAt . takeOff

memoize :: (Int -> a) -> (Int -> a)
memoize f = (map f [0 ..] !!)
