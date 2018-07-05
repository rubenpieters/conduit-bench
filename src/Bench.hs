module Bench where

import qualified ConduitBench

main :: IO ()
main = ConduitBench.runPrimes 10000
