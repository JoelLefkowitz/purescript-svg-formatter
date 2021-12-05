module Test.Data.String.Regex.Matchers where

import Prelude
import Data.Maybe (Maybe(..))
import Data.String.Regex.Matchers (validate, select, selectAll, pickGroup, pickGroups)
import Test.Unit (describe, it, TestSuite, suite)
import Test.Unit.Assert (shouldEqual)

testMatchers :: TestSuite
testMatchers =
  suite "Matching single regex groups." do
    describe "validate" do
      it "'abc' 'a.*' -> bool" do
        validate "" "" `shouldEqual` true
        validate ".*" "123" `shouldEqual` true
        validate ".+" "a" `shouldEqual` true

-- describe "Handles invalid regex expressions." do
--   it "Returns Nothing when given an invalid regex expression." do
--     matchFirst "[0-9]++" "" "" `shouldEqual` Nothing

-- describe "Matches a single regex capture group." do
--   it "Returns Nothing when no matching group is present." do
--     matchFirst """<(\d)>""" "" "<a>" `shouldEqual` Nothing
--   it "Returns Just the matching group." do
--     matchFirst """([a-z])([3-5])""" "" "a1b2" `shouldEqual` Just "<12>"
--   it "Returns Just the first of multiple matching groups." do
--     matchFirst """<(\d)>""" "" "<1><2>" `shouldEqual` Just "1"
--   it "Returns Just matches of the first capture group." do
--     matchFirst """<(\d)>""" "" "<a>" `shouldEqual` Nothing
