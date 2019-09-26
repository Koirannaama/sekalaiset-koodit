import Data.List (sort)

discardFactorsOf :: Int -> [Int] -> [Int]
discardFactorsOf number [] = []
discardFactorsOf number (x:xs) = 
  if number `mod` x == 0 
    then discardFactorsOf number xs 
    else x : (discardFactorsOf number xs)

discardUnneededFactors :: [Int] -> [Int]
discardUnneededFactors [] = []
discardUnneededFactors range = x : (discardUnneededFactors $ discardFactorsOf x xs)
  where (x:xs) = (reverse . sort) range

isDivisibleByAll :: Int -> [Int] -> Bool
isDivisibleByAll number [] = True
isDivisibleByAll number (x:xs) =
  if (number `mod` x == 0)
    then (isDivisibleByAll number xs)
    else False

-- Naive primality checking
isPrime :: Int -> Bool
isPrime 1 = True
isPrime 2 = True
isPrime n = helper (n-1)
  where helper 1 = True
        helper divisor = if (n `mod` divisor == 0) then False else helper (divisor-1)

getProductOfMaxAndPrimes :: [Int] -> Int
getProductOfMaxAndPrimes numbers = max * multiplyPrimesIn rest
  where (max:rest) = (reverse . sort) numbers
        multiplyPrimesIn [] = 1
        multiplyPrimesIn (n:ns) =
          if isPrime n then n * (multiplyPrimesIn ns) else multiplyPrimesIn ns


smallestNumberDivisibleByNumbersUpTo :: Int -> Int
smallestNumberDivisibleByNumbersUpTo number = findSmallest step
  where neededFactors = discardUnneededFactors [1..number]
        step = getProductOfMaxAndPrimes neededFactors
        findSmallest candidate = 
          if isDivisibleByAll candidate neededFactors
            then candidate else findSmallest (candidate + step)

smallestEvenlyDivisbleUpTo20 :: Int
smallestEvenlyDivisbleUpTo20 = smallestNumberDivisibleByNumbersUpTo 20