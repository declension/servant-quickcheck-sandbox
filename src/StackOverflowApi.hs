{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module StackOverflowApi where

import Data.Text
import Data.Aeson (FromJSON)
import Servant
import GHC.Generics

-- any-api.com/portal_v2/console?swaggerURL=https%3A%2F%2Fany-api.com%2Fmodels%2Fstackexchange.com%2F2.0#/GET /tags?answers={"inname":"testing","order":"asc","sort":"name","site":"stackoverflow"}

type StackOverflowAPI =
    "tags"
        :> QueryParam "site" SiteName
        :> QueryParam "inname" SearchTerm
        :> Get '[JSON] TagResponse

data TagResponse = TagResponse {
  items :: [Tag]
} deriving (Eq, Show, Read, Generic, FromJSON)

data Tag = Tag {
  name :: Text,
  count :: Int
} deriving (Eq, Show, Read, Generic, FromJSON)

newtype SiteName = SiteName Text
instance ToHttpApiData SiteName
  where toUrlPiece (SiteName ss) = ss


newtype SearchTerm = SearchTerm Text
instance ToHttpApiData SearchTerm
  where toUrlPiece (SearchTerm st) = st

soApi :: Proxy StackOverflowAPI
soApi = Proxy
