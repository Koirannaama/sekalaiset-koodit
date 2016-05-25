-- DelftX: FP101x Introduction to Functional Programming
-- Just a minimal attempt at interactivity inspired by the
-- interactive programs lecture

countKs :: String -> Int
countKs x = foldr (\c s -> if c == 'k' then s + 1 else s) 0 x

getInput :: IO String
getInput =
  do putStrLn "Enter something, exit with Q"
     input <- getLine
     return input

doInteraction :: IO String
doInteraction =
  do
    input <- getInput
    if input == "Q" then
      return input
    else
      do
        putStrLn ("You entered " ++ (show $ countKs input) ++ " ks")
        doInteraction

main = doInteraction
