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
