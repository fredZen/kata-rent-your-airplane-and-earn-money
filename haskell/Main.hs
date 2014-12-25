module Main where

import Control.Arrow
import Data.Function
import Data.List
import Data.Map (Map, (!))
import qualified Data.Map as Map
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as BS

main :: IO ()
main = BS.interact solve

solve :: ByteString -> ByteString
solve = parse >>> map (profit >>> show >>> BS.pack) >>> BS.unlines

type Timestamp = Int
type Duration = Int
type Money = Int

data Order = Order { takeOff :: Timestamp
                   , duration :: Duration
                   , price :: Money }
             deriving (Eq, Show)

type Problem = [Order]

parse :: ByteString -> [Problem]
parse = BS.lines >>> (map BS.words) >>> (map $ map (BS.readInt >>> \ (Just (i, _)) -> i)) >>> parseProblems

parseProblems :: [[Int]] -> [Problem]
parseProblems ([numProblems]:lines) = snd $ mapAccumL (flip ($)) lines parsers
    where parsers = replicate numProblems parseProblem

parseProblem :: [[Int]] -> ([[Int]], Problem)
parseProblem ([numOrders]:ls) = (rest, map makeOrder orders)
    where (orders, rest) = splitAt numOrders ls

makeOrder :: [Int] -> Order
makeOrder [t, d, p] = Order t d p

landing :: Order -> Timestamp
landing = compose (+) takeOff duration

compose :: (b -> b' -> c) -> (a -> b) -> (a -> b') -> (a -> c)
compose f g h = uncurry f ^<< g &&& h

data Plan = Plan { ordersByLanding :: Map Timestamp [Order]
                 , times :: [Timestamp] }

profit :: Problem -> Money
profit [] = 0
profit os = (foldr (addProfit $ ordersByLanding p) Map.empty (times p)) ! (head (times p))
    where p = plan os

addProfit :: Map Timestamp [Order] -> Timestamp -> Map Timestamp Money -> Map Timestamp Money
addProfit ordersByLanding l profitByLanding = Map.insert l maxProfit profitByLanding
  where maxProfit = maybe 0 (maximum . map profitFor) $ Map.lookup l ordersByLanding
        profitFor = compose (+) price $ (profitByLanding !) . takeOff

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
