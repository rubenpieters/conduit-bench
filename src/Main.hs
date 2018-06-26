module Main where

import qualified ConduitBench
import Control.Monad
import System.Environment

runX x = replicateM_ x (ConduitBench.runPrimes 10000)

main =
  do args <- getArgs;
      let n = read (args !! 0) :: Int in runX n

