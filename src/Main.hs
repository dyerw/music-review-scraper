{-# LANGUAGE OverloadedStrings #-}
module Main where

import Network.Wreq
import Control.Lens
import qualified Data.ByteString.Lazy as SL

getPitchforkAlbumReviewsPage :: IO SL.ByteString
getPitchforkAlbumReviewsPage = do
  r <- get "http://httpbin.org/get"
  return $ r ^. responseBody

main :: IO ()
main = do
  r <- getPitchforkAlbumReviewsPage
  print r
