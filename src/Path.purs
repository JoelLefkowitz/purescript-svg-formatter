module Data.SVG.Formatter.Path where

import Prelude
import Data.Maybe (Maybe(..))
import Data.String.CodePoints (uncons, singleton)
import Data.Foldable (foldl)
import Data.Traversable (traverse)
import Data.String.Regex.Matchers (select)

formatPath :: String -> Maybe String
formatPath str = do
  path <- pickPath str
  segments <- pickSegments path
  segments' <- traverse parseSegment segments
  pure $ joinSegments segments'

pickPath :: String -> Maybe String
pickPath = select ""

pickSegments :: String -> Maybe (Array String)
pickSegments str = Just [ str ]

parseSegment :: String -> Maybe String
parseSegment str = case head str of
  Just "H" -> Just ""
  _ -> Nothing

type PathSegments
  = { "A" :: Array Int
    , "C" :: Array Int
    , "H" :: Array Int
    , "L" :: Array Int
    , "M" :: Array Int
    , "Q" :: Array Int
    , "S" :: Array Int
    , "T" :: Array Int
    , "V" :: Array Int
    }

pathSegments :: PathSegments
pathSegments =
  { "A": [ 2, 3, 2 ]
  , "C": [ 2, 2, 2 ]
  , "H": [ 1 ]
  , "L": [ 2 ]
  , "M": [ 2 ]
  , "Q": [ 2, 2 ]
  , "S": [ 2, 2 ]
  , "T": [ 2 ]
  , "V": [ 1 ]
  }

joinSegments :: Array String -> String
joinSegments arr = foldl (\acc x -> acc <> x) "" arr

head :: String -> Maybe String
head str = do
  x <- uncons str
  pure $ singleton x.head
