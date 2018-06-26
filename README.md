# conduit-bench

Showcase of performance behaviour I did not expect.

Running `runPrimes 10000` once takes about 4.6 seconds on my machine, but running it multiple times consecutively with for example `replicateM_ 2 (runPrimes 10000)` does not increase the runtime.

This behaviour dominates the data when trying to benchmark with for example criterion.
