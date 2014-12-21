module Main where

import Test.Hspec
import Lags

main :: IO ()
main = hspec $ do
    describe "profit" $ do
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
