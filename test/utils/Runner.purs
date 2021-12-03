module Test.Unit.Output.Minimal
  ( runTest
  ) where

import Prelude
import Data.Either (Either(Left, Right))
import Data.List (List, length)
import Data.String.CodeUnits (singleton)
import Data.Tuple (Tuple(Tuple))
import Effect (Effect)
import Effect.Aff (attempt, Aff)
import Effect.Class (liftEffect)
import Effect.Exception (message)
import Test.Unit (TestList, TestSuite, walkSuite)
import Test.Unit.Console (printFail, savePos, restorePos, eraseLine, printPass, printLabel, print)

indent :: Int -> String
indent n
  | n > 0 = "  " <> indent (n - 1)
  | otherwise = mempty

printIndent :: forall a. List a -> Effect Unit
printIndent = print <<< indent <<< length

heading :: Char -> String -> String
heading char str = singleton char <> " " <> str <> ": "

printLive :: TestSuite -> Aff TestList
printLive tst = walkSuite runSuiteItem tst
  where
  runSuiteItem path (Left label) = do
    liftEffect do
      printIndent path
      print $ heading '\x2192' "Suite"
      printLabel label
      void $ print "\n"

  runSuiteItem path (Right (Tuple label t)) = do
    liftEffect do
      printIndent path
      savePos
      print $ heading '\x2192' "Running"
      printLabel label
      restorePos
    result <- attempt t
    void
      $ case result of
          (Right _) ->
            liftEffect do
              eraseLine
              printPass $ heading '\x2713' "Passed"
              printLabel label
              print "\n"
          (Left err) ->
            liftEffect do
              eraseLine
              printFail $ heading '\x2717' "Failed"
              printLabel label
              print "\n"
              restorePos
              printFail $ message err
              print "\n\n"

runTest :: TestSuite -> Aff TestList
runTest suite = do
  tests <- printLive suite
  pure tests
