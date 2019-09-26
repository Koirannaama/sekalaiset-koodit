sumMultiplesOf3And5 :: Int -> Int
sumMultiplesOf3And5 n
  | n < 1 = 0
  | (n `mod` 3 == 0) || (n `mod` 5 == 0) = n + sumMultiplesOf3And5 (n - 1)
  | otherwise = 0 + sumMultiplesOf3And5 (n - 1)

sumMultiplesOf3And5Below :: Int -> Int
sumMultiplesOf3And5Below n = sumMultiplesOf3And5 (n - 1)

sumMultiplesOf3And5Below1000 :: Int
sumMultiplesOf3And5Below1000 = sumMultiplesOf3And5Below 1000