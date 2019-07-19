module LoginModel exposing (Model, LoginMode(..), FormValidationError(..), LoginError(..), update, initModel, isLoginVisible)

import LoginMsg exposing (Msg(..))
import API exposing (APILoginRequestError(..), authenticate, register, getLoginError)

type LoginMode = Login | Register

type FormValidationError = UnmatchingPasswords | MissingFields

type LoginError = LoginRequestError APILoginRequestError | ValidationError FormValidationError

type alias Model = 
  { username: String
  , password: String
  , passwordRepeat: String
  , isVisible: Bool
  , error: Maybe LoginError
  , mode: LoginMode
  }

type alias LoginTranslation msg =
  { loginMsg: Msg -> msg
  , loginResultMsg: msg  
  }

initModel : Model
initModel = 
  { username = ""
  , password = ""
  , passwordRepeat = ""
  , isVisible = False
  , error = Nothing
  , mode = Login
  }

update : Msg -> Model -> String -> (Model, Cmd Msg)
update msg model token =
  case msg of
    UsernameInput input ->
      ({ model | username = input }, Cmd.none)

    PasswordInput input ->
      ({ model | password = input }, Cmd.none)

    PasswordRepeatInput input ->
      ({ model | passwordRepeat = input }, Cmd.none)

    OpenLogin ->
      ({ model | isVisible = True }, Cmd.none)

    CloseLogin ->
      ({ model | isVisible = False }, Cmd.none)

    SubmitLogin ->
      let
        validationError = validateForm model
      in
        case validationError of
          Just err -> ({ model | error = Just <| ValidationError err }, Cmd.none)
          Nothing -> (model, loginCmd model token)

    FormKeyPress keyCode ->
      case keyCode of
        13 -> (model, loginCmd model token)
        _ -> (model, Cmd.none)

    LoginResponse (Ok _ ) -> (initModel, Cmd.none)
    LoginResponse (Err error) -> 
      let
        loginError = getLoginError error
      in
        ({ model | error = Just <| LoginRequestError loginError }, Cmd.none)

    SwitchMode ->
      let
        newMode =
          case model.mode of
            Login -> Register
            Register -> Login
      in
        ({ model | mode = newMode, error = Nothing }, Cmd.none)

    RegisterResponse res -> Debug.log "register response" (model, Cmd.none)
          

isLoginVisible : Model -> Bool
isLoginVisible model = model.isVisible

translateMsg : LoginTranslation msg -> Msg -> msg
translateMsg { loginMsg, loginResultMsg } msg =
  case msg of
    LoginResponse (Ok _) ->
      loginResultMsg
    _ ->
      loginMsg msg
    
loginCmd : Model -> String -> Cmd Msg
loginCmd model token =
  case model.mode of
    Login ->
      let
        creds = { username = model.username, password = model.password }
      in
        authenticate creds token LoginResponse

    Register ->
      let
        reg = { username = model.username, password = model.password, passwordRepeat = model.passwordRepeat }
      in
        register reg token RegisterResponse

validateForm : Model -> Maybe FormValidationError
validateForm model =
  case model.mode of 
    Register ->
      if model.username == "" || model.password == "" || model.passwordRepeat == "" then
        Just <| MissingFields
      else if model.password /= model.passwordRepeat then
        Just <| UnmatchingPasswords
      else
        Nothing
    Login ->
      if model.username == "" || model.password == "" then
        Just <| MissingFields
      else
        Nothing
  --model.mode == Register && model.password == model.passwordRepeat