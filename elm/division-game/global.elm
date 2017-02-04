module Global exposing (Msg(..))

import Keyboard

type Msg =
  KeyMsg Keyboard.KeyCode
  | InputMsg String
  | RandomNum Int
