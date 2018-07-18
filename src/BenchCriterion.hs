module BenchCriterion where

import qualified ConduitBench

import Gauge

main = defaultMain
  [ bench "nfIOf" (nfAppIO ConduitBench.runPrimes 10000)
  , bench "nfIO" (nfIO (ConduitBench.runPrimes 10000))
  ]
