{-# LANGUAGE OverloadedStrings #-}
module StackOverflowSpec where

import Test.Hspec
import Servant.QuickCheck
import Test.QuickCheck (Arbitrary, arbitrary, stdArgs)

import Api

--burl = BaseUrl Https "api.stackexchange.com" 80 "2.2"
burl = BaseUrl Http "localhost" 8080 "/2.2"

spec :: Spec
spec = return ()
--spec = describe "The Stack Overflow API" $
--    it "returns JSON successfully" $
--      serverSatisfies soApi burl stdArgs
--        (not500
--         <%> onlyJsonObjects
--         <%> mempty)


instance Arbitrary SiteString
  where arbitrary = return $ SiteString "stackoverflow"

instance Arbitrary SearchTerm
  where arbitrary = do
--                        t <- arbitrary
--                        return $ SearchTerm (T.pack t)
                        return $ SearchTerm "haskell"
