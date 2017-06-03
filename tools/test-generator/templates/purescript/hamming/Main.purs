module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert as Assert
import Data.List (List, fromFoldable)
import Data.String as String
import Hamming (distance)

main :: Eff _ Unit
main = runTest do
  suite "hamming" do
--TEST
    test "$description" $
      Assert.equal $expected (distance $strand1 $strand2)
--END TEST
