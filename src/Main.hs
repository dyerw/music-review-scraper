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

allPitchforkReviews :: IO (Maybe [AlbumReview])
allPitchforkReviews = scrapeURL "https://pitchfork.com/reviews/albums/" reviews
  where
    reviews :: Scraper String [AlbumReview]
    reviews = chroots ("div" @: [hasClass "review"]) review

    review :: Scraper String AlbumReview
    review = do
      artistName <- text "li"
      albumName <- text $ "div" @: [hasClass "review__title-album"]
      return $ AlbumReview artistName albumName

getPitchforkAlbumReviewsPage :: IO SL.ByteString
getPitchforkAlbumReviewsPage = do
  r <- get "https://pitchfork.com/reviews/albums/"
  return $ r ^. responseBody



main :: IO ()
main = do
  r <- getPitchforkAlbumReviewsPage
  print r
