module LoginMsg exposing (Msg(..))

import Http

type Msg =
  UsernameInput String
  | PasswordInput String
  | PasswordRepeatInput String
  | OpenLogin
  | CloseLogin
  | SubmitLogin
  | FormKeyPress Int
  | LoginResponse (Result Http.Error (Bool, String))
  | SwitchMode
  | RegisterResponse (Result Http.Error String)
