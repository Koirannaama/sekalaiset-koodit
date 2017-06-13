module Components exposing (..)

import Html exposing (Html, Attribute, button, span)

iconButton : List (Attribute msg) -> Attribute msg -> Html msg
iconButton attributes iconClass =
  button attributes [
    span [ iconClass ] []
  ]