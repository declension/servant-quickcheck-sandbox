{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module StackExchangeApi where

import Data.Text
import Data.Aeson (FromJSON)
import Servant
import GHC.Generics

-- Our test Tag API
type StackExchangeAPI =
    "tags"
        :> QueryParam "site" SiteName
        :> QueryParam "inname" SearchTerm
        :> Get '[JSON] TagResponse

-- An actual (Proxy) instance of the above
api :: Proxy StackExchangeAPI
api = Proxy

-- The response type
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
