{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Api where

import Data.Text
import Data.Aeson (FromJSON)
import Servant
import GHC.Generics

-- any-api.com/portal_v2/console?swaggerURL=https%3A%2F%2Fany-api.com%2Fmodels%2Fstackexchange.com%2F2.0#/GET /tags?answers={"inname":"testing","order":"asc","sort":"name","site":"stackoverflow"}

type StackOverflowAPI =
    "tags"
        :> QueryParam "site" SiteString
        :> QueryParam "inname" SearchTerm
        :> Get '[JSON] [Tag]

data Tag = Tag {
  name :: Text,
  count :: Int,
  has_synonyms :: Bool,
  is_moderator_only :: Bool
} deriving (Eq, Show, Read, FromJSON, Generic)

newtype SiteString = SiteString Text
instance ToHttpApiData SiteString
  where toUrlPiece (SiteString ss) = ss


newtype SearchTerm = SearchTerm Text
instance ToHttpApiData SearchTerm
  where toUrlPiece (SearchTerm st) = st

-- Dummy stuff
type TestAPI = "/path" :> "/sub" :> Get '[JSON] Int
testApi :: Proxy TestAPI
testApi = Proxy


soApi :: Proxy StackOverflowAPI
soApi = Proxy
