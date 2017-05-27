module View exposing (..)

import Html exposing (Html)
import GalleryView exposing (view)
import PhotoView exposing (view)
import Model exposing (Model, Route(..))
import Msg exposing (Msg)

getView : Model -> Html Msg
getView model =
  case model.route of
    PhotoRoute -> PhotoView.view model
    GalleryRoute -> GalleryView.view
    NotFoundRoute -> GalleryView.view