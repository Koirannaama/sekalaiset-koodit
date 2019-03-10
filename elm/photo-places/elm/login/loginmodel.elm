--import Cmd exposing (map)

module LoginModel exposing (Model, update, initModel, isLoginVisible)

import LoginMsg exposing (Msg(..))
import API exposing (LoginError(..), authenticate, getLoginError)

type alias Model = 
  { username: String
  , password: String
  , isVisible: Bool
  , errorMsg: String
  }

type alias LoginTranslation msg =
  { loginMsg: Msg -> msg
  , loginResultMsg: msg  
  }

initModel : Model
initModel = 
  { username = ""
  , password = ""
  , isVisible = False
  , errorMsg = ""
  }

update : Msg -> Model -> String -> (Model, Cmd Msg)
update msg model token =
  case msg of
    UsernameInput input ->
      ({ model | username = input }, Cmd.none)

    PasswordInput input ->
      ({ model | password = input }, Cmd.none)

    OpenLogin ->
      ({ model | isVisible = True }, Cmd.none)

    CloseLogin ->
      ({ model | isVisible = False }, Cmd.none)

    SubmitLogin ->
      (model, loginCmd model token)

    FormKeyPress keyCode ->
      case keyCode of
        13 -> (model, loginCmd model token)
        _ -> (model, Cmd.none)

    LoginResponse (Ok _ ) -> (initModel, Cmd.none)
    LoginResponse (Err error) -> 
      let
        loginError = getLoginError error
      in
        ({ model | errorMsg = getLoginErrorMessage loginError }, Cmd.none)
          

isLoginVisible : Model -> Bool
isLoginVisible model = model.isVisible

translateMsg : LoginTranslation msg -> Msg -> msg
translateMsg { loginMsg, loginResultMsg } msg =
  case msg of
    LoginResponse (Ok _) ->
      loginResultMsg
    _ ->
      loginMsg msg

getLoginErrorMessage : LoginError -> String
getLoginErrorMessage err =
  case err of
    BadCredentials -> "Incorrect username or password"
    ServerError -> "Error when logging in"
    
loginCmd : Model -> String -> Cmd Msg
loginCmd model token =
  let
    creds = { username = model.username, password = model.password }
  in
    authenticate creds token LoginResponse
