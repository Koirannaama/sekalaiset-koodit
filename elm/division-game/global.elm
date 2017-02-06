module Global exposing (Msg(..))

import Keyboard
import Http
import Task

type Msg =
  KeyMsg Keyboard.KeyCode
  | InputMsg String
  | RandomNum Int
  | HighScores (List (String, Int))
