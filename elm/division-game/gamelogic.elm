module GameLogic exposing (getResult, GuessResult(..))

import Arithmetic exposing (isPrime)

type GuessResult =
  Prime
  | Odd
  | Even
  | Trivial
  | Wrong

getResult : Int -> Int -> Int -> (GuessResult, Int)
getResult answer number currentPoints =
  let
    result = getGuessResult answer number
    points = getPointsForResult result currentPoints
  in
  (result, points)

isAnswerCorrect : Int -> Int -> Bool
isAnswerCorrect answer number =
  if answer == 0 then
    isPrime number
  else
    number % answer == 0

getGuessResult : Int -> Int -> GuessResult
getGuessResult answer number =
  if isAnswerCorrect answer number then
    if answer == 0 then
      Prime
    else if answer == 1 || answer == number then
      Trivial
    else if answer == 2 then
      Even
    else
      Odd
  else
    Wrong

getPointsForResult : GuessResult -> Int -> Int
getPointsForResult result currentPoints =
  case result of
    Prime -> 3 + currentPoints
    Odd -> 2 + currentPoints
    Even -> 1 + currentPoints
    Trivial -> currentPoints
    Wrong -> 0
