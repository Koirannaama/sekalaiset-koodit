module LoginView exposing (loginDialog)

import Html exposing (Html, Attribute, div, form, input, label, text, span, button)
import Html.Attributes exposing (class, value, classList, for, id, type_)
import Html.Events exposing (onInput, onClick, onSubmit, keyCode, on)
import Json.Decode as Json
import LoginModel exposing (Model)
import LoginMsg exposing (Msg(..))


loginDialog : Model -> Bool -> Html Msg
loginDialog model isVisible =
  div [ classList [("hidden", not isVisible)] ]
    [ div [ class "modal-dialog" ] 
      [ loginHeader
      , (loginForm model) ]
    , div [ class "modal-dialog-backdrop", (onClick CloseLogin) ] []
    ]

loginHeader : Html msg
loginHeader =
  div [ class "login-header"] 
    [ span [] [ text "Log in" ] ]

loginForm : Model -> Html Msg
loginForm model =
  div [ class "login-form" ]
    [ loginField "Username" model.username "username" "text" UsernameInput
    , loginField "Password" model.password "password" "password" PasswordInput
    , button [ class "login-btn", onClick SubmitLogin ] [ text "Log in" ]
    , span [ class "error-msg" ] [ text model.errorMsg ]
    ]


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

onKeyDown : (Int -> Msg) -> Attribute Msg
onKeyDown tagger = on "keydown" (Json.map tagger keyCode) 
  