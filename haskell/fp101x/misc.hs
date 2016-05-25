-- DelftX: FP101x Introduction to Functional Programming
-- Sekalaisia pienempiä tehtäviä

evens :: [Integer] -> [Integer]
evens xs = [x | x <- xs, even x]

squares :: Integer -> [Integer]
squares x = [n*n | n <- [1..x]]

squares' :: Integer -> Integer -> [Integer]
squares' m n = [x*x | x <- [(1+n)..(n+m)]]

coords :: Integer -> Integer -> [(Integer, Integer)]
coords m n = [(x, y) | x <- [0..m], y <- [0..n]]

triangle :: Integer -> Integer
triangle n = foldr (\x s -> x + s) 0 xs
  where xs = [0..n]

count :: Eq a => a -> [a] -> Integer
count a [] = 0
count a (x:xs) = if x == a then 1 + (count a xs) else count a xs

subtractGrtrFromLsr :: Integer -> Integer -> Integer
subtractGrtrFromLsr x y
  | x > y = x - y
  | otherwise = y - x

euclid :: (Integer, Integer) -> Integer
euclid (_, 0) = 0
euclid (0, _) = 0
euclid (x, y)
  | x == y = y
  | x > y = euclid ((x - y), y)
  | otherwise = euclid (x, (y - x))
