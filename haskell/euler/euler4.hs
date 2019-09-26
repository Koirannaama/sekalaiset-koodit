toDigits :: Int -> [Int]
toDigits number
  | number < 10 = [number]
  | otherwise = rem : (toDigits $ (number - rem) `quot` 10)
  where rem = number `mod` 10

isPalindrome :: [Int] -> Bool
isPalindrome [] = True
isPalindrome (x:[]) = True
isPalindrome (x:xs) = x == (last xs) && (isPalindrome $ init xs)

isNumberPalindrome :: Int -> Bool
isNumberPalindrome = isPalindrome . toDigits

iterateFactors :: Int -> Int -> Int -> Int -> Int
iterateFactors fac1 fac2 maxFac2 currentLargestPalindrome
  | fac1 == 100 = currentLargestPalindrome
  | otherwise = iterateFactors nextFac1 nextFac2 nextMaxFac2 newLargestPali
  where candidate = fac1*fac2
        largerPaliFound = candidate > currentLargestPalindrome && isNumberPalindrome candidate
        startNewRound = fac2 == 100 || (fac1*fac2) < currentLargestPalindrome
        nextFac1 = if startNewRound then fac1-1 else fac1
        nextFac2 = if startNewRound then maxFac2-1 else fac2-1
        nextMaxFac2 = if startNewRound then maxFac2-1 else maxFac2
        newLargestPali = if largerPaliFound then (fac1*fac2) else currentLargestPalindrome

largestPalindrome :: Int
largestPalindrome = iterateFactors 999 999 999 0