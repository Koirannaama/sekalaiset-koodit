-- DelftX: FP101x Introduction to Functional Programming
-- Luottokorttinumeroharkka

lukuNumeroiksi :: Int -> [Int]
lukuNumeroiksi n
  | n < 10 = [n]
  | otherwise =  jaannos : lukuNumeroiksi (n `div` 10)
    where jaannos = n `mod` 10

tuplaaJokaToinen :: [Int] -> [Int]
tuplaaJokaToinen [] = []
tuplaaJokaToinen [x] = [x]
tuplaaJokaToinen (x:y:xs) = x : 2*y : tuplaaJokaToinen xs

jaaKaksinumeroiset :: [Int] -> [Int]
jaaKaksinumeroiset [] = []
jaaKaksinumeroiset (x:xs)
  | x > 9 = (lukuNumeroiksi x) ++ (jaaKaksinumeroiset xs)
  | otherwise = x : jaaKaksinumeroiset xs

summaaNumerot :: [Int] -> Int
summaaNumerot [] = 0
summaaNumerot (x:xs) = x + summaaNumerot xs

kelpaako :: Int -> Bool
kelpaako l = summaaNumerot nt `mod` 10 == 0
  where nt = jaaKaksinumeroiset $ tuplaaJokaToinen $ lukuNumeroiksi l
