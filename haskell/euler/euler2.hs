sumEvenFibos :: Int -> Int -> Int -> Int
sumEvenFibos limit prevFibo1 prevFibo2
  | prevFibo1 > limit = 0
  | prevFibo1 `mod` 2 == 0 = prevFibo1 + sumEvenFibos limit prevFibo2 newFibo
  | otherwise = 0 + sumEvenFibos limit prevFibo2 newFibo
  where newFibo = prevFibo1 + prevFibo2

sumEvenFibosLessThan :: Int -> Int
sumEvenFibosLessThan n = sumEvenFibos n 1 2

sumOfEvenFibosLessThan4000000 :: Int
sumOfEvenFibosLessThan4000000 = sumEvenFibosLessThan 4000000