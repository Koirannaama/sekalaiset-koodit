--import Cmd exposing (map)

module LoginModel exposing (Model, update, initModel, isLoginVisible)

import LoginMsg exposing (Msg(..))
import API

type alias Model = 
  { username: String
  , password: String
  , isVisible: Bool
  }

type alias LoginTranslation msg =
  { loginMsg: Msg -> msg
  , loginResultMsg: msg  
  }

initModel : Model
initModel = 
  { username = ""
  , password = ""
  , isVisible = True
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
      let
        creds = { username = model.username, password = model.password }
        authCmd = API.authenticate creds token LoginResponse
      in
        (model, authCmd)

    FormKeyPress keyCode ->
      case keyCode of
        13 -> (model, Cmd.none)
        _ -> (model, Cmd.none)

    LoginResponse (Ok _) -> (model, Cmd.none)
    LoginResponse (Err _) -> (model, Cmd.none)
          

isLoginVisible : Model -> Bool
isLoginVisible model = model.isVisible

translateMsg : LoginTranslation msg -> Msg -> msg
translateMsg { loginMsg, loginResultMsg } msg =
  case msg of
    LoginResponse (Ok _) ->
      loginResultMsg
    _ ->
      loginMsg msg
    
