module View exposing (..)

import Html exposing (Html, div, map)
import Html.Attributes exposing (class)
import GalleryView exposing (view)
import PhotoView exposing (view)
import LoginView exposing (loginDialog)
import Model exposing (Model, Route(..), isLoginVisible)
import Msg exposing (Msg(LoginMsg))
import Components exposing (topBar)

--TODO: consider Html.map for handling Msg types from sub-views

getView : Model.Model -> Html Msg
getView model =
  let
    login = Html.map LoginMsg (loginDialog model.loginModel)
    base = viewBase model.navMenuOpen (isLoginVisible model) model.isLoggedIn login
  in
    case model.route of
      PhotoRoute -> PhotoView.view base model.photoModel
      GalleryRoute -> GalleryView.view base
      NotFoundRoute -> GalleryView.view base

viewBase : Bool -> Bool -> Bool -> Html Msg -> List (Html Msg.Msg) -> List (Html Msg.Msg) -> String -> Html Msg.Msg
viewBase isNavMenuOpen isLoginOpen isLoggedIn loginDialog topBarControls content topLevelClassName =
  let
    topBarElem = topBar isNavMenuOpen isLoggedIn topBarControls
    baseElements = if isLoginOpen then [ loginDialog, topBarElem ] else [ topBarElem ]
  in
    div [ class topLevelClassName ]
       (List.append baseElements content)