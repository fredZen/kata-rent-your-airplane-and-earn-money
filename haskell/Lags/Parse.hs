module Lags.Parse where

import Control.Arrow
import Data.List
import Lags.Order
import Lags.Memo
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as BS

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

solve :: ByteString -> ByteString
solve = parse >>> map (profit >>> show >>> BS.pack) >>> BS.unlines
