{-# LANGUAGE OverloadedStrings #-}
module ApiSpec where

import Test.Hspec
import Test.QuickCheck
import Servant.QuickCheck

import Api

burl = BaseUrl Http "localhost" 8080 ""

spec :: Spec
spec = do
    it "Dummy API doesn't return 500" $
      serverSatisfies testApi burl stdArgs
        (not500
         <%> mempty)

instance Arbitrary SafeText
    where arbitrary = return $ SafeText "value"
