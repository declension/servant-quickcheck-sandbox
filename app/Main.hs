{-# LANGUAGE OverloadedStrings #-}
module Main where

import Servant.Client
import Network.HTTP.Client (newManager, defaultManagerSettings)

import Api

getTags = client soApi


foo :: IO [String]
foo = return ["foo"]

query :: ClientM [Tag]
query = do
  tags <- getTags (Just $ SiteString "stackoverflow") (Just $ SearchTerm "haskell")
  return tags

main :: IO ()
main = do
  manager <- newManager defaultManagerSettings
  res <- runClientM query (ClientEnv manager (BaseUrl Http "localhost" 8080 ""))
  case res of
    Left err -> putStrLn $ "Error: " ++ show err
    Right tags -> print tags
