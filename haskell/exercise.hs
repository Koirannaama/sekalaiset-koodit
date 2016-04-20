myForEach :: [a] -> (a -> b) -> [b]
myForEach [] _ = []
myForEach (x:xs) f = (f x) : (myForEach xs f)

myForAny :: [a] -> (a -> Bool) -> Bool
myForAny [] _ = False
myForAny (x:xs) f
  | f x == True = True
  | otherwise = myForAny xs f

myForAll :: [a] -> (a -> Bool) -> Bool
myForAll xs f = not (myForAny xs (not . f))

mergeSort :: (Ord a) => [a] -> [a]
mergeSort [] = []
mergeSort (x:[]) = [x]
mergeSort xs = merge x1 x2
  where x1 = mergeSort $ take (((length xs) + 1) `div` 2) xs
        x2 = mergeSort $ drop (((length xs) + 1) `div` 2) xs

merge :: (Ord a) => [a] -> [a] -> [a]
merge xs [] = xs
merge [] xs = xs
merge (x:xs) (y:ys)
  | x < y = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys
