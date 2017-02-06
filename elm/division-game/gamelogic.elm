module GameLogic exposing (getResult, GuessResult(..), randomNumCmd)

import Arithmetic exposing (isPrime)
import Platform.Cmd exposing (Cmd, none)
import Random
import Global exposing (Msg)

type GuessResult =
  Prime
  | Odd
  | Even
  | Trivial
  | Wrong

randomNumCmd : Cmd Msg
randomNumCmd = Random.generate Global.RandomNum (Random.int 1 100)

getResult : Int -> Int -> Int -> (GuessResult, Int, Cmd Msg)
getResult answer number currentPoints =
  let
    result = getGuessResult answer number
    points = getPointsForResult result currentPoints
    command = getCommandForResult result
  in
  (result, points, command)

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

getCommandForResult : GuessResult -> Cmd Msg
getCommandForResult result =
  case result of
    Prime -> randomNumCmd
    Odd -> randomNumCmd
    Even -> randomNumCmd
    Trivial -> Cmd.none
    Wrong -> randomNumCmd
