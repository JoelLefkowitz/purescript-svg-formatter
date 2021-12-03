{ name = "svg-formatter"
, dependencies = [ "console"
  , "effect"
  , "psci-support"
  , "strings"
  , "stringutils"
  , "test-unit"
  , "foldable-traversable"
  , "debug"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
