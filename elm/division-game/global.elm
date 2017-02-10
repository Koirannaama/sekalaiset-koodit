module Global exposing (Msg(..), Score, comparePoints)

import Keyboard
import Http
import Task

type Msg =
  KeyMsg Keyboard.KeyCode
  | InputMsg String
  | RandomNum Int
  | HighScores (List Score)

type alias Score = (String, Int)

comparePoints : Score -> Score -> Order
comparePoints (name1, score1) (name2, score2) =
  case compare score1 score2 of
    GT -> LT
    EQ -> EQ
    LT -> GT
