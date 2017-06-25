module GalleryView exposing (..)

import Html exposing (Html, div, input, text)
import Html.Attributes exposing (class)
import Msg exposing (Msg(GalleryMsg))
--import GalleryModel exposing (Msg(..))

view : (List (Html Msg.Msg) -> Html Msg.Msg) -> Html Msg.Msg --Msg.Msg
view topBar = 
  div [ class "gallery-container"]
    [ topBar [] ]