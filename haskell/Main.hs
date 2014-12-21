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
