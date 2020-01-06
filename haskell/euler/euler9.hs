iterateTripletsFrom :: Int -> Int -> (Int, Int, Int)
iterateTripletsFrom a b
  | (a^2 + b^2 == c^2) = (a,b,c)
  | b > c || c < 0 = iterateTripletsFrom (a+1) (a+2)
  | otherwise = iterateTripletsFrom a (b+1)
  where c = 1000 - a - b

specialPythagoreanTripletProduct :: Int
specialPythagoreanTripletProduct = a * b * c
  where (a, b, c) = iterateTripletsFrom 1 2