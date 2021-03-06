module ConduitBench where

import Control.Monad

import Conduit

upfrom :: (Monad m) => Int -> ConduitT x Int m b
upfrom n = do
  yield n
  upfrom (n+1)

filter :: (Monad m) => (a -> Bool) -> ConduitT a a m b
filter test = forever $
  do
    mX <- await
    case mX of
      Just x -> if test x
        then yield x
        else return ()
      Nothing -> return ()

take :: (Monad m) => Int -> ConduitT a a m ()
take n = if n == 0
  then return ()
  else do
    mX <- await
    case mX of
      Just x -> do
        yield x
        ConduitBench.take (n - 1)
      Nothing -> return ()

sieve :: (Monad m) => ConduitT Int Int m ()
sieve = do
  mP <- await
  case mP of
    Just p -> do
      yield p
      ConduitBench.filter (\x -> x `mod` p /= 0) .| sieve
    Nothing -> return ()

primes :: (Monad m) => Int -> ConduitT () Int m ()
primes n = upfrom 2 .| sieve .| ConduitBench.take n

iter :: Int -> (a -> a) -> a -> a
iter n f x = loop n x where
  loop k y = if k == 0 then y else loop (k-1) (f y)

deepPipe :: (Monad m) => Int -> ConduitT () Int m x
deepPipe n = iter n (forever (return ()) .|) (forever (yield 0))

deepSeq :: (Monad m) => Int -> ConduitT () Int m x
deepSeq n = iter n (>> forever (return ())) (forever (yield 0))

conduitRead :: (Read o) => ConduitT i o IO ()
conduitRead = forever $ do
  x <- lift readLn
  yield x

conduitShow :: (Show i) => ConduitT i o IO ()
conduitShow = do
  mX <- await
  case mX of
    Just x -> do
      lift (print x)
      conduitShow
    Nothing -> return ()

runConduitIO :: (Read i, Show o) => ConduitT i o IO () -> IO ()
runConduitIO conduit = runConduit (conduitRead .| conduit .| conduitShow)

runPrimes :: Int -> IO ()
runPrimes n = runConduitIO (primes n)

runDeepPipe :: Int -> IO ()
runDeepPipe n = runConduitIO (deepPipe n .| ConduitBench.take n)

runDeepSeq :: Int -> IO ()
runDeepSeq n = runConduitIO (deepSeq n .| ConduitBench.take n)

