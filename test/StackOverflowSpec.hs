{-# LANGUAGE OverloadedStrings #-}
module StackOverflowSpec where

import Test.Hspec
import Servant.QuickCheck
import Test.QuickCheck (Arbitrary, arbitrary, stdArgs, elements)

import Api

--burl = BaseUrl Https "api.stackexchange.com" 80 "2.2"
burl = BaseUrl Http "localhost" 8080 "/2.2"

spec :: Spec
spec = describe "The Stack Overflow API" $
    it "returns JSON objects without error" $
      serverSatisfies soApi burl stdArgs
        (not500
         <%> onlyJsonObjects
         <%> mempty)


instance Arbitrary SiteName
  where arbitrary = return $ SiteName "stackoverflow"

instance Arbitrary SearchTerm
  where arbitrary = do
          term <- elements ["haskell", "quickcheck", "servant"]
          return (SearchTerm term)
