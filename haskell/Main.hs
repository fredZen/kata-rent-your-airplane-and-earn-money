module Main where

import Test.Hspec
import Lags

main :: IO ()
main = hspec $ do
    describe "profit" $ do
        it "should be zero when there is no order" $ do
            (profit []) `shouldBe` 0
