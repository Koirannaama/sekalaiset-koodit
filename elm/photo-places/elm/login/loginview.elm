module LoginView exposing (loginDialog)

import Html exposing (Html, div, form, input, button, label, text)
import Html.Attributes exposing (class, value, classList, for, id)
import Html.Events exposing (onInput, onClick)
import LoginModel exposing (Msg(..), Model)


loginDialog : Model -> Bool -> Html Msg
loginDialog model isVisible =
  div [ classList [("hidden", not isVisible)] ]
    [ div [ class "modal-dialog" ] [ (loginForm model) ]
    , div [ class "modal-dialog-backdrop", (onClick CloseLogin) ] []
    ]

loginForm : Model -> Html Msg
loginForm model =
  form []
    [ loginField "Username" model.username "username" UsernameInput
    , loginField "Password" model.password "password" PasswordInput
    ]


loginField : String -> String -> String -> (String -> Msg) -> Html Msg
loginField labelText inputValue inputID inputMsg =
  div []
    [ label [ for inputID ] [ text labelText ]
    , input [ onInput inputMsg, value inputValue, id inputID ] []
    ]