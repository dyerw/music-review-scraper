{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Lens
import qualified Data.ByteString.Lazy as SL
import qualified Data.Text            as T
import           Network.Wreq
import           Text.HTML.Scalpel

type AlbumName = String
type ArtistName = String
data AlbumReview = AlbumReview ArtistName AlbumName deriving (Show, Eq)

pitchforkURL :: String
pitchforkURL = "https://pitchfork.com/reviews/albums/"

allPitchforkReviews :: IO (Maybe [AlbumReview])
allPitchforkReviews = scrapeURL pitchforkURL reviews
  where
    reviews :: Scraper String [AlbumReview]
    reviews = chroots (("div" @: [hasClass "review"]) // ("a" @: [hasClass "review__link"])) review

    review :: Scraper String AlbumReview
    review = do
      artistName <- text $ ("div" @: [hasClass "review__title"]) // ("ul" @: [hasClass "artist-list"]) // "li"
      albumName  <- text $ ("div" @: [hasClass "review__title"]) // "h2"
      return $ AlbumReview artistName albumName

getPitchforkAlbumReviewsPage :: IO SL.ByteString
getPitchforkAlbumReviewsPage = do
  r <- get "https://pitchfork.com/reviews/albums/"
  return $ r ^. responseBody



main :: IO ()
main = do
  r <- getPitchforkAlbumReviewsPage
  print r
