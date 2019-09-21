module LoginMsg exposing (Msg(..))

import API exposing (APIError)

type Msg =
  UsernameInput String
  | PasswordInput String
  | PasswordRepeatInput String
  | OpenLogin
  | CloseLogin
  | SubmitLogin
  | FormKeyPress Int
  | LoginResponse (Result APIError (Bool, String))
  | SwitchMode
  | RegisterResponse (Result APIError String)
