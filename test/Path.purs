module Test.Data.SVG.Formatter.Path where

import Prelude
import Data.Maybe (Maybe(..))
import Data.SVG.Formatter.Path (formatPath)
import Data.String.Common (trim)
import Test.Unit (describe, it, TestSuite, suite)
import Test.Unit.Assert (shouldEqual)
import Test.Unit.Assert.Foldable (shouldAllEqual)


testFormatPath :: TestSuite
testFormatPath =
  suite "Formatting paths." do
    describe "Handles invalid inputs." do
      it "Returns Nothing when given an invalid path." do
        formatPath
          `map`
            [ ""
            , "<>"
            , "<path>"
            , "<path d= />"
            , "<path d=\"X Z\"/>"
            , "<path d=\"H H Z\"/>"
            , "<path d=\"H 1\"/>"
            ]
          `shouldAllEqual`
            Nothing

    describe "Formats paths segments." do
      it "Leaves an empty path unchanged." do
        formatPath "<path />" `shouldEqual` Just "<path />"
        formatPath "<path></path>" `shouldEqual` Just "<path></path>"
        formatPath "<path d=\"\"/>" `shouldEqual` Just "<path d=\"\"/>"
      
      it "Parses an 'H', or 'V' style segment." do
        formatPath
          `map`
            [ "<path d=\"H 1 Z\"/>"
            , "<path d=\"H1 Z\"/>"
            , "<path d=\"H 1Z\"/>"
            , "<path d=\"H1Z\"/>"
            ]
          `shouldAllEqual`
            Just "<path d=\"H 1 Z\"/>"
      
      it "Parses an 'M', 'L' or 'T' style segment." do
        formatPath
          `map`
            [ "<path d=\"M 1,2 Z\"/>"
            , "<path d=\"M 1 2 Z\"/>"
            , "<path d=\"M1 2Z\"/>"
            , "<path d=\"M1  2Z\"/>"
            , "<path d=\"M1\n2Z\"/>"
            ]
          `shouldAllEqual`
            Just "<path d=\"M 1,2 Z\"/>"
      
      it "Parses an 'S', 'Q' style segment." do
        formatPath
          `map`
            [ "<path d=\"S 1,2 3,4 Z\"/>"
            , "<path d=\"S 1 2 3 4 Z\"/>"
            , "<path d=\"S1 2 3 4Z\"/>"
            , "<path d=\"S1  2  3  4Z\"/>"
            , "<path d=\"S1\n2 3\n4Z\"/>"
            ]
          `shouldAllEqual`
            Just "<path d=\"S 1,2 3,4 Z\"/>"
      
      it "Parses a 'C' style segment." do
        formatPath
          `map`
            [ "<path d=\"C 1,2 3,4 5,6 Z\"/>"
            , "<path d=\"C 1 2 3 4 5 6 Z\"/>"
            , "<path d=\"C1 2 3 4 5 6Z\"/>"
            , "<path d=\"C1  2  3  4  5  6Z\"/>"
            , "<path d=\"C1\n2 3\n4 5\n6Z\"/>"
            ]
          `shouldAllEqual`
            Just "<path d=\"C 1,2 3,4 5,6 Z\"/>"
      
      it "Parses an 'A' style segment." do
        formatPath
          `map`
            [ "<path d=\"A 1,2 3,4,5 6,7 Z\"/>"
            , "<path d=\"A 1 2 3 4 5 6 7 Z\"/>"
            , "<path d=\"A1 2 3 4 5 6 7Z\"/>"
            , "<path d=\"A1  2  3  4  5  6  7Z\"/>"
            , "<path d=\"A1\n2 3\n4 5\n6 7Z\"/>"
            ]
          `shouldAllEqual`
            Just "<path d=\"A 1,2 3,4,5 6,7 Z\"/>"
      
      it "Parses lowercase segments." do
        formatPath "<path d=\"m 1,2 z\"/>" `shouldEqual` Just "<path d=\"m 1,2 z\"/>"

    describe "Formats complex paths sequences." do
      it "Formats multiple segments." do
        formatPath "<path d=\"M1 2M3 4C1 2 3 4 5 6Z\"/>"
          `shouldEqual`
            Just
               ( trim
                   """<path d="M 1,2 
                               M 3,4
                               C 1,2 3,4 5,6
                               Z"/>"""
              )
