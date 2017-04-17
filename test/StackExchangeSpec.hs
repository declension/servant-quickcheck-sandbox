{-# LANGUAGE OverloadedStrings #-}
module StackExchangeSpec where

import           Test.Hspec (Spec, it, describe)
import           Servant.QuickCheck
import           Servant.QuickCheck.Internal.Predicates (honoursAcceptHeader)
import           Servant.QuickCheck.Internal.ErrorTypes (PredicateFailure(PredicateFailure))
import           Test.QuickCheck (Arbitrary, arbitrary, stdArgs, elements)
import           Network.HTTP.Types (status200, status300)
import           Network.HTTP.Client (responseStatus)
import           Control.Exception (throw)
import qualified Data.Text as T
import           Control.Monad (replicateM)

import           StackExchangeApi


spec :: Spec
spec = describe "The Stack Exchange API" $
    it "returns success with JSON objects and best practice headers" $
      serverSatisfies api baseUrl stdArgs {maxSuccess = 10}
        (isSuccess
         <%> onlyJsonObjects
         <%> notLongerThan (500 * millisInNanos)
         <%> honoursAcceptHeader
         <%> mempty)
      where millisInNanos = 1000 * 1000
--            baseUrl = BaseUrl Http "api.stackexchange.com" 80 "/2.2"
            baseUrl = BaseUrl Http "localhost" 8080 "/2.2"

isSuccess :: ResponsePredicate
isSuccess = ResponsePredicate p
  where rs = responseStatus
        p resp
          | rs resp `between` (status200, status300) = return ()
          | otherwise = throw $ PredicateFailure "isSuccess" Nothing resp
        between x (bottom, top) = bottom <= x && x < top

instance Arbitrary SiteName
  where arbitrary = return $ SiteName "stackoverflow"

instance Arbitrary SearchTerm
  where arbitrary = do
          term <- elements ["haskell", "quickcheck", "servant"]
          return (SearchTerm term)


chars = '-' : ['a'..'z']

instance Arbitrary TagName
  where arbitrary = do
            s <- replicateM 6 $ elements chars
            return $ TagName $ T.pack s
