module Lags.Parse where

import Control.Arrow
import Data.List
import Lags.Order
import Lags.Memo

parse :: String -> [Problem]
parse = lines >>> (map words) >>> (map $ map read) >>> parseProblems

parseProblems :: [[Int]] -> [Problem]
parseProblems ([numProblems]:lines) = snd $ mapAccumL (flip ($)) lines parsers
    where parsers = replicate numProblems parseProblem

parseProblem :: [[Int]] -> ([[Int]], Problem)
parseProblem ([numOrders]:ls) = (rest, map makeOrder orders)
    where (orders, rest) = splitAt numOrders ls

makeOrder :: [Int] -> Order
makeOrder [t, d, p] = Order t d p

solve :: String -> String
solve = parse >>> map (profit >>> show) >>> unlines
