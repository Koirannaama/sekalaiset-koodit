module View exposing (..)

import Html exposing (Html)
import GalleryView exposing (view)
import PhotoView exposing (view)
import Model exposing (Model, Route(..), getRoute)
import Msg exposing (Msg)

getView : Model -> Html Msg
getView model =
  case Model.getRoute model of
    PhotoRoute -> PhotoView.view model
    GalleryRoute -> GalleryView.view
    NotFoundRoute -> GalleryView.view