--tehtäviä exercism.io:sta

isSublist :: (Eq a) => [a] -> [a] -> Bool
isSublist [] _ = True
isSublist _ [] = False
isSublist xs ys
  | xs == take (length xs) ys = True
  | otherwise = isSublist xs (tail ys)

keep :: (a -> Bool) -> [a] -> [a]
keep p xs = foldr (\x xs -> if p x then x : xs else xs) [] xs
