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
memoize f = (fmap f (naturals 1 0) !!!)

data NaturalTree a = Node a (NaturalTree a) (NaturalTree a)

naturals r n =
   Node n
     ((naturals $! r2) $! (n+r))
     ((naturals $! r2) $! (n+r2))
        where r2 = 2*r

instance Functor NaturalTree where
   fmap f (Node a tl tr) = Node (f a) (fmap f tl) (fmap f tr)

Node a tl tr !!! 0 = a
Node a tl tr !!! n =
   if odd n
     then tl !!! top
     else tr !!! (top-1)
        where top = n `div` 2
