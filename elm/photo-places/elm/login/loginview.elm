module LoginView exposing (loginDialog)

import Html exposing (Html, Attribute, div, form, input, label, text, span, button, a)
import Html.Attributes exposing (class, value, classList, for, id, type_)
import Html.Events exposing (onInput, onClick, onSubmit, keyCode, on)
import Json.Decode as Json
import LoginModel exposing (Model, LoginMode(..), LoginError(..), FormValidationError(..))
import LoginMsg exposing (Msg(..))
import API exposing (APIError(..))


loginDialog : Model -> Html Msg
loginDialog model =
  div []
    [ div [ class "modal-dialog" ] 
      [ (loginHeader model)
      , (loginForm model) ]
    , div [ class "modal-dialog-backdrop", (onClick CloseLogin) ] []
    ]

loginHeader : Model -> Html msg
loginHeader model =
  div [ class "login-header"] 
    [ span [] [ text <| currentModeText model.mode ] ]

loginForm : Model -> Html Msg
loginForm model =
  let
    errorMsg = 
      case model.error of
        Just err -> getLoginErrorMessage err
        Nothing -> ""
    topFields = 
      [ loginField "Username" model.username "username" "text" UsernameInput
      , loginField "Password" model.password "password" "password" PasswordInput ]
    repeatPasswordField =
      loginField "Repeat password" model.passwordRepeat "password-repeat" "password" PasswordRepeatInput
    bottomFields =
      [ button [ class "login-btn", onClick SubmitLogin ] [ text <| currentModeText model.mode ]
      , span [ class "error-msg" ] [ text <| errorMsg ]
      , modeSwitch model.mode ]
    formFields = if model.mode == Register 
                 then topFields ++ [repeatPasswordField] ++ bottomFields
                 else topFields ++ bottomFields
  in
    div [ class "login-form" ] formFields

loginField : String -> String -> String -> String -> (String -> Msg) -> Html Msg
loginField labelText inputValue inputID typeAttr inputMsg =
  div [ class "login-field" ]
    [ label [ for inputID ] [ text labelText ]
    , input [ class "input-box"
            , onInput inputMsg
            , value inputValue
            , id inputID
            , onKeyDown FormKeyPress
            , type_ typeAttr ]
            []
    ]

switchModeText : LoginMode -> String
switchModeText mode =
  case mode of
    Login -> "Register"
    Register -> "Log in"

currentModeText : LoginMode -> String 
currentModeText mode =
  case mode of 
    Login -> "Log in"
    Register -> "Register"

onKeyDown : (Int -> Msg) -> Attribute Msg
onKeyDown tagger = on "keydown" (Json.map tagger keyCode) 
  
modeSwitch : LoginMode -> Html Msg
modeSwitch currentMode =
  a [ class "login-mode-switch", onClick SwitchMode ] [ text <| switchModeText currentMode ]

getLoginErrorMessage : LoginError -> String
getLoginErrorMessage err =
  case err of
    LoginRequestError requestErr ->
      case requestErr of
        UsernameTaken -> "This username has already been taken"
        InvalidData -> "All fields must be filled"
        BadCredentials -> "Incorrect username or password"
        ServerError -> "Error when logging in"
        _ -> "Something went wrong"

    ValidationError validationErr ->
      case validationErr of
        UnmatchingPasswords -> "Passwords don't match"
        MissingFields -> "All fields must be filled"