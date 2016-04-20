import qualified Data.Map as Map

-- Counts the immediate successors of every string in a list of string.
-- successorCounter ["koira", "kissa", "hiiri", "marsu"]
-- == [("koira", (1, "kissa")),
--     ("kissa", (1, "hiiri")),
--     ("hiiri", (1, "marsu"))]

successorCounter :: [String] -> Map.Map String [(Int, String)] -> Map.Map String [(Int, String)]
successorCounter [] m = m
successorCounter (x:[]) m = m
successorCounter (x:y:xs) m
  | not (Map.member x m) = successorCounter (y:xs) (Map.insert x [(1, y)] m)
  | otherwise = Map.insert x (incrementOrAddEntry y (m Map.! x)) m

incrementOrAddEntry :: String -> [(Int, String)] -> [(Int, String)]
incrementOrAddEntry y [] = [(1, y)]
incrementOrAddEntry y (t:ts)
  | y /= (snd t) = t : (incrementOrAddEntry y ts)
  | otherwise = ((fst t) + 1, y) : ts
