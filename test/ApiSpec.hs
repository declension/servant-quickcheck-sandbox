module ApiSpec where

import Test.Hspec
import Test.QuickCheck
import Servant.QuickCheck

import Api

burl = BaseUrl Http "localhost" 8080 ""

spec :: Spec
spec = describe "The dummy API" $ do
    it "doesn't return 500" $ do
      serverSatisfies testApi burl stdArgs { chatty = True}
        (not500
         <%> mempty)
