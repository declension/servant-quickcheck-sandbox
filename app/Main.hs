{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import           Data.Monoid ((<>))
import           Network.HTTP.Client (newManager, defaultManagerSettings, managerModifyRequest)
import           System.Environment (getArgs)
import           Servant.Client
import           Servant.API

import StackExchangeApi

-- Convenience
stackOverflowSite = Just $ SiteName "stackoverflow"

-- Our endpoint to query against
baseUrl = BaseUrl Http "api.stackexchange.com" 80 "/2.2"

-- Set up the API client with pattern matching
getTags :: Maybe SiteName -> Maybe SearchTerm -> ClientM (Response Tag)
getQuestions :: Maybe SiteName -> Maybe TagName -> ClientM (Response Question)
getTags :<|> getQuestions = client api

queryTags :: SearchTerm -> ClientM [Tag]
queryTags searchTerm = do
  theTags <- getTags stackOverflowSite (Just searchTerm)
  return $ items theTags

queryQs :: TagName -> ClientM [Question]
queryQs tagName = items <$> getQuestions stackOverflowSite (Just tagName)

logIt :: Show a => a -> IO a
logIt req = print req >> return req

main :: IO ()
main = do
  args <- getArgs
  let st = case args of
       s : _ -> T.pack s
       []    -> ""
  manager <- newManager defaultManagerSettings {managerModifyRequest = logIt}
  tagRes <- runClientM (queryTags (SearchTerm st)) (ClientEnv manager baseUrl)
  case tagRes of
    Left err   -> fail (show err)
    Right theTags -> mapM_ (TIO.putStrLn . name) theTags

  qsRes <- runClientM (queryQs (TagName st)) (ClientEnv manager baseUrl)
  case qsRes of
      Left err   -> fail (show err)
      Right theQs -> mapM_ (TIO.putStrLn . formatQuestion) theQs

formatQuestion :: Question -> T.Text
formatQuestion q =  title q <> " (" <> link q <> ")"
