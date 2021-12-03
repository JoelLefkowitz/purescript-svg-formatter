module Test.Unit.Assert.Foldable where

import Prelude
import Effect.Aff (Aff)
import Data.Foldable (class Foldable)
import Data.Traversable (traverse_)
import Test.Unit.Assert (equal)


shouldAllEqual :: forall f a. Foldable f => Eq a => Show a => f a -> a -> Aff Unit
shouldAllEqual arr expected = traverse_ (equal expected) arr
