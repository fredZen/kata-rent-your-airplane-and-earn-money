module Main where

import Test.Hspec

main :: IO ()
main = hspec $ do
    describe "dummy test" $ do
        it "should succeed" $ do
            1 `shouldBe` 1
        it "should fail" $ do
            1 `shouldBe` 2
