module View exposing (..)

import Html exposing (Html)
import GalleryView exposing (view)
import PhotoView exposing (view)
import Model exposing (Model, Route(..))
import Msg exposing (Msg)
import Components exposing (topBar)

getView : Model -> Html Msg
getView model =
  let
    topBarComponent = topBar model.navMenuOpen
  in
    case model.route of
      PhotoRoute -> PhotoView.view topBarComponent model.photoModel
      GalleryRoute -> GalleryView.view topBarComponent
      NotFoundRoute -> GalleryView.view topBarComponent