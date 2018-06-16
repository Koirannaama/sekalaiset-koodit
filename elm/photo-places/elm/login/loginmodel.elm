module LoginModel exposing (Msg(..), Model, update, initModel, isLoginVisible)

type Msg =
  UsernameInput String
  | PasswordInput String
  | OpenLogin
  | CloseLogin
  | SubmitLogin

type alias Model = 
  { username: String
  , password: String
  , isVisible: Bool
  }

initModel : Model
initModel = 
  { username = ""
  , password = ""
  , isVisible = True
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
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
      (model, Cmd.none)

isLoginVisible : Model -> Bool
isLoginVisible model = model.isVisible