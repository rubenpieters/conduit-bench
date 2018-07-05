module BenchCriterion where

import qualified ConduitBench

import Criterion.Main

main = defaultMain
  [ bench "nfIOf" (nfIOf ConduitBench.runPrimes 10000)
  , bench "nfIO" (nfIO (ConduitBench.runPrimes 10000))
  ]
