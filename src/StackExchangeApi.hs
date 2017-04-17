{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module StackExchangeApi where

import Data.Text  (Text)
import Data.Aeson (FromJSON, Value(String), parseJSON)
import GHC.Generics (Generic)
import Servant

-- Our test Tag API
type StackExchangeAPI =
         "tags"
            :> QueryParam "site" SiteName
            :> QueryParam "inname" SearchTerm
            :> Get '[JSON] (Response Tag)
    :<|> "questions"
            :> QueryParam "site" SiteName
            :> QueryParam "tagged" TagName
            :> Get '[JSON] (Response Question)

-- An actual (Proxy) instance of the above
api :: Proxy StackExchangeAPI
api = Proxy

-- The response wrapper
data Response a = Response {
  items :: [a]
} deriving (Eq, Show, Read, Generic, FromJSON)

data Tag = Tag {
  name :: Text,
  count :: Int
} deriving (Eq, Show, Read, Generic, FromJSON)

data Question = Question {
  title :: Text,
  link :: Text,
  tags :: [TagName]
} deriving (Eq, Show, Read, Generic, FromJSON)

newtype TagName = TagName { fromTagName :: Text }
  deriving (Eq, Show, Read)
instance ToHttpApiData TagName
  where toUrlPiece (TagName tn) = tn
instance FromJSON TagName
  where parseJSON (String s) = return $ TagName s
        parseJSON _ = mempty

newtype SiteName = SiteName Text
instance ToHttpApiData SiteName
  where toUrlPiece (SiteName ss) = ss

newtype SearchTerm = SearchTerm Text
instance ToHttpApiData SearchTerm
  where toUrlPiece (SearchTerm st) = st
