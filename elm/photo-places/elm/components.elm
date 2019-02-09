module Components exposing (iconButton, topBar)

import Html exposing (Html, Attribute, div, button, span, form, text, a)
import Html.Attributes exposing (class, action, classList, href)
import Html.Events exposing (onClick)
import Routing exposing (galleryPath, photoPath)
import Msg exposing (Msg(ToggleNavMenu, LoginMsg, Logout))
import LoginMsg exposing (Msg(OpenLogin))

iconButton : List (Attribute msg) -> Attribute msg -> Html msg
iconButton attributes iconClass =
  button attributes [
    span [ iconClass ] []
  ]

topBar : Bool -> Bool -> List (Html Msg.Msg) -> Html Msg.Msg
topBar isNavMenuVisible isLoggedIn controls =
  div [ class "top-bar no-side-pad row col-md-12" ] 
    [ div [ class "col-md-9 col-xs-10 full-height"] controls
    , navButtons isLoggedIn
    , navMenu isNavMenuVisible
    ] 

navButtons : Bool -> Html Msg.Msg
navButtons isLoggedIn =
  div [ class "col-md-3 col-xs-2 text-right nav-button-container" ] 
    [ loginButton isLoggedIn [ class "nav-link hidden-xs"]
    , searchLink [class "nav-link hidden-xs"]
    , galleryLink [class "nav-link hidden-xs"]
    , burgerButton
    ]

navLink : String -> String -> List (Attribute msg) -> Html msg
navLink path linkText attributes = 
  a (href path :: attributes) [ text linkText ]

galleryLink : List (Attribute msg) -> Html msg
galleryLink =
  navLink galleryPath "Gallery"

searchLink : List (Attribute msg) -> Html msg
searchLink = 
  navLink photoPath "Search"

burgerButton : Html Msg.Msg
burgerButton = 
  iconButton 
    [ class "button float-right visible-xs", onClick ToggleNavMenu] 
    (class "glyphicon glyphicon-menu-hamburger")

navMenu : Bool -> Html Msg.Msg
navMenu isVisible =
  let
    classes = classList [("nav-menu", True), ("hidden", not isVisible)]
  in 
    div [ classes ] 
      [ searchLink [class "nav-link nav-menu-item"]
      , galleryLink [class "nav-link nav-menu-item"]
      ]

loginButton : Bool ->List (Attribute Msg.Msg) -> Html Msg.Msg
loginButton isLoggedIn attributes =
  let
    (buttonText, cmd) = if isLoggedIn then ("Logout", Logout) else ("Login", LoginMsg OpenLogin)
  in  
    a ((onClick cmd) :: attributes) [ text buttonText ]