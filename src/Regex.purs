module Data.String.Regex.Matchers where

import Prelude
import Data.Maybe (Maybe(..), isJust)
import Data.Array.NonEmpty (head, tail)
import Data.Either (hush)
import Data.Traversable (sequence)
import Data.String.Regex as Regex

type Match
  = { segment :: String
    , groups :: Array String
    }

match :: String -> String -> String -> Maybe Match
match regex flags str = do
  pattern <- hush <<< Regex.regex regex $ Regex.parseFlags flags
  arr <- Regex.match pattern str
  segment <- head arr
  groups <- sequence $ tail arr
  pure { segment, groups }

matchAll :: String -> String -> String -> Maybe (Array Match)
matchAll regex flags str = Just []

validate :: String -> String -> Boolean
validate regex str = isJust $ match regex "" str

select :: String -> String -> Maybe String
select regex str = do
  m <- match regex "" str
  pure m.segment

selectAll :: String -> String -> Maybe (Array String)
selectAll regex str = Just []

pickGroup :: String -> String -> Maybe String
pickGroup regex str = Just ""

pickGroups :: String -> String -> Maybe (Array String)
pickGroups regex str = Just []
