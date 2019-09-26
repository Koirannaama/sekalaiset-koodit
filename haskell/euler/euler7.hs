isDivisibleByAnyPrime :: Int -> [Int] -> Bool
isDivisibleByAnyPrime number [] = False
isDivisibleByAnyPrime number (prime:primes)
  | (fromIntegral prime) > sqrt (fromIntegral number) = False
  | number `mod` prime == 0 = True
  | otherwise = isDivisibleByAnyPrime number primes

collectNPrimes :: Int -> [Int]
collectNPrimes n = iteratePrimes 3 [2] 1
  where iteratePrimes candidate primesFound numberOfPrimesFound
          | numberOfPrimesFound >= n = primesFound
          | isDivisibleByAnyPrime candidate primesFound = iteratePrimes (candidate+2) primesFound numberOfPrimesFound
          | otherwise = iteratePrimes (candidate+2) (primesFound ++ [candidate]) (numberOfPrimesFound+1)

get10001NthPrime :: Int
get10001NthPrime = last $ collectNPrimes 10001