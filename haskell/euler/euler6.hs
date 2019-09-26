sumOfSquaresBetween :: Int -> Int -> Int
sumOfSquaresBetween lowBound hiBound =
  foldl squareAndAdd 0 [lowBound..hiBound]
  where squareAndAdd sum num = sum + num^2

squareOfSumBetween :: Int -> Int -> Int
squareOfSumBetween lowBound hiBound =
  (^ 2) $ foldl (+) 0 [lowBound..hiBound]

subtractSumOfSquaresFromSquareOfSumBetween :: Int -> Int -> Int
subtractSumOfSquaresFromSquareOfSumBetween lowBound hiBound =
  (squareOfSumBetween lowBound hiBound) - (sumOfSquaresBetween lowBound hiBound)

squareSumSumSquareDiffOf100First :: Int
squareSumSumSquareDiffOf100First = subtractSumOfSquaresFromSquareOfSumBetween 0 100