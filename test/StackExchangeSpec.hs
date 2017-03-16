{-# LANGUAGE OverloadedStrings #-}
module StackExchangeSpec where

import Test.Hspec
import Servant.QuickCheck
import Test.QuickCheck (Arbitrary, arbitrary, stdArgs, elements)

import StackExchangeApi

-- Let's test locally for now...
baseUrl = BaseUrl Http "localhost" 8080 "/2.2"

spec :: Spec
spec = describe "The Stack Exchange API" $
    it "returns JSON objects without error" $
      serverSatisfies api baseUrl stdArgs
        (not500
         <%> onlyJsonObjects
         <%> mempty)


instance Arbitrary SiteName
  where arbitrary = return $ SiteName "stackoverflow"

instance Arbitrary SearchTerm
  where arbitrary = do
          term <- elements ["haskell", "quickcheck", "servant"]
          return (SearchTerm term)
