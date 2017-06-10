module Components exposing (..)

import Html exposing (Html, Attribute, button, span)
--import Html.Attributes exposing (class)
--import Msg exposing (Msg)


iconButton : List (Attribute msg) -> Attribute msg -> Html msg
iconButton attributes iconClass =
  button attributes [
    span [ iconClass ] []
  ]