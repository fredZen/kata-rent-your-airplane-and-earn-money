module Spec where

import Data.Map
import qualified Lags.Fold
import qualified Lags.Memo
import Lags.Order
import Lags.Parse
import Test.Hspec
import Data.ByteString.Char8 (pack)

lagsSpec profit = do
    it "should be zero when there is no order" $ do
        (profit []) `shouldBe` 0

    it "should be the price of the only order" $ do
        (profit [Order 0 5 17]) `shouldBe` 17

    it "should be the price of the more expensive of two overlapping orders" $ do
        (profit [Order 0 5 17, Order 0 5 10]) `shouldBe` 17
        (profit [Order 0 5 10, Order 0 5 17]) `shouldBe` 17

    it "should not be disturbed by out-of-order arrival times" $ do
        (profit [Order 0 5 17, Order 0 3 3, Order 0 5 10]) `shouldBe` 17

    it "should be the sum of the prices of two consecutive orders" $ do
        (profit [Order 0 5 17, Order 5 5 10]) `shouldBe` 27

    it "work with gaps between orders" $ do
        (profit [Order 0 4 17, Order 5 5 10]) `shouldBe` 27

main :: IO ()
main = hspec $ do
    describe "Compute profit by folding" $
        lagsSpec Lags.Fold.profit

    describe "Compute profit by memoizing" $
        lagsSpec Lags.Memo.profit

    describe "plan" $ do
        it "connects times with free flights" $ do
            let p = plan [Order 0 4 17, Order 5 5 10]
            (Data.Map.lookup 5 $ ordersByLanding p) `shouldBe` (Just [Order 4 1 0])

    describe "SPOJ parser" $ do
        it "finds a single problem with a single order" $ do
            (parse . pack $ unlines [ "1"
                            , "1"
                            , "0 5 10"]) `shouldBe` [[Order 0 5 10]]

        it "finds 2 orders" $ do
            (parse . pack $ unlines [ "1"
                            , "2"
                            , "0 5 10"
                            , "3 7 12"]) `shouldBe` [[Order 0 5 10, Order 3 7 12]]

        it "finds 2 problemts" $ do
            (parse . pack $ unlines [ "2"
                            , "1"
                            , "0 5 10"
                            , "1"
                            , "3 7 12"]) `shouldBe` [[Order 0 5 10], [Order 3 7 12]]

    describe "SPOJ solver" $ do
        it "finds the solution to the standard problem" $ do
            (solve . pack $ unlines [ "1"
                            , "4"
                            , "0 5 10"
                            , "3 7 14"
                            , "5 9 7"
                            , "6 9 8" ]) `shouldBe` (pack $ unlines ["18"])
