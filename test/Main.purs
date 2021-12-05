module Test.Main where

import Prelude
import Effect (Effect)
import Test.Unit.Main (runTestWith, run)
import Test.Unit.Output.Minimal (runTest)
import Test.Data.SVG.Formatter.Path (testFormatPath)
import Test.Data.String.Regex.Matchers (testMatchers)

main :: Effect Unit
main =
  (run <<< runTestWith runTest) do
    testFormatPath
    testMatchers
