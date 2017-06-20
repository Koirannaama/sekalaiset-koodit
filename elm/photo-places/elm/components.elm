module Components exposing (iconButton, topBar)

import Html exposing (Html, Attribute, div, button, span, form, text)
import Html.Attributes exposing (class, action)
import Routing exposing( galleryPath, photoPath)

iconButton : List (Attribute msg) -> Attribute msg -> Html msg
iconButton attributes iconClass =
  button attributes [
    span [ iconClass ] []
  ]

topBar : List (Html msg) -> Html msg
topBar controls =
  div [ class "top-bar no-side-pad row col-md-12" ] 
    [ div [ class "col-md-9 col-xs-9 full-height"] controls
    , navButtons
    ] 

navButtons : Html msg
navButtons =
  div [ class "col-md-3 col-xs-3 text-right nav-button-container" ] 
    -- TODO: replace forms with links
    [ form [ class "nav-form", action photoPath] [button [ class "button" ] [ text "Search" ]]
    , form [ class "nav-form", action galleryPath] [button [ class "button" ] [ text "Gallery" ]]
    ]