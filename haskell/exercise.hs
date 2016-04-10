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
