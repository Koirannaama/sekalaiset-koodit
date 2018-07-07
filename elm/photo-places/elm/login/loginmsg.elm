module LoginMsg exposing (Msg(..))

import Http

type Msg =
  UsernameInput String
  | PasswordInput String
  | OpenLogin
  | CloseLogin
  | SubmitLogin
  | FormKeyPress Int
  | LoginResponse (Result Http.Error Bool)
