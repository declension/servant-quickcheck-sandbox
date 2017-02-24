{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Servant.Client
import Network.HTTP.Client (newManager, defaultManagerSettings, managerModifyRequest)

import Api

-- Set up the API client with pattern matching
getTags :: Maybe SiteString -> Maybe SearchTerm -> ClientM TagResponse
getTags = client soApi

query :: ClientM [Tag]
query = do
  tags <- getTags (Just $ SiteString "stackoverflow") (Just $ SearchTerm "haskell")
  return $ items tags

logIt :: Show a => a -> IO a
logIt req = print req >> return req

main :: IO ()
main = do
  manager <- newManager defaultManagerSettings {
    managerModifyRequest = logIt
  }
  res <- runClientM query (ClientEnv manager (BaseUrl Http "api.stackexchange.com" 80 "/2.2"))
  case res of
    Left err -> putStrLn $ "Error: " ++ show err
    Right tags -> TIO.putStrLn $ T.intercalate "\n" $ fmap name tags
