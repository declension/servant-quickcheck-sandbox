{-# LANGUAGE OverloadedStrings #-}
module StackOverflowSpec where

import Test.Hspec
import Test.QuickCheck
import Servant.QuickCheck
import Test.QuickCheck (Arbitrary, arbitrary)
import qualified Data.Text as T

import Api

--burl = BaseUrl Https "api.stackexchange.com" 80 "2.2"
burl = BaseUrl Http "localhost" 8080 ""

spec :: Spec
spec = describe "The Stack Overflow API" $ do
    it "doesn't return 500" $ do
      serverSatisfies soApi burl stdArgs
        (not500
         <%> mempty)



instance Arbitrary SiteString
  where arbitrary = return $ SiteString "stackoverflow"

instance Arbitrary SearchTerm
  where arbitrary = do
                        t <- arbitrary
                        return $ SearchTerm (T.pack t)
