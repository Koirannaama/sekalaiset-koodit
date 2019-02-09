module View exposing (..)

import Html exposing (Html, div, map)
import Html.Attributes exposing (class)
import GalleryView exposing (view)
import PhotoView exposing (view)
import LoginView exposing (loginDialog)
import Model exposing (Model, Route(..), isLoginVisible)
import Msg exposing (Msg(LoginMsg))
import Components exposing (topBar)
import LoginModel exposing (Model)

--TODO: consider Html.map for handling Msg types from sub-views

getView : Model.Model -> Html Msg
getView model =
  let
    base = viewBase model.navMenuOpen (isLoginVisible model) model.isLoggedIn model.loginModel
  in
    case model.route of
      PhotoRoute -> PhotoView.view base model.photoModel
      GalleryRoute -> GalleryView.view base
      NotFoundRoute -> GalleryView.view base

viewBase : Bool -> Bool -> Bool -> LoginModel.Model -> List (Html Msg.Msg) -> List (Html Msg.Msg) -> String -> Html Msg.Msg
viewBase isNavMenuOpen isLoginOpen isLoggedIn loginModel topBarControls content topLevelClassName =
  let
    login = Html.map LoginMsg (loginDialog loginModel isLoginOpen)
    baseElements = 
      [ login --loginDialog isLoginOpen
      , topBar isNavMenuOpen isLoggedIn topBarControls
      ]
  in
    div [ class topLevelClassName ]
       (List.append baseElements content)