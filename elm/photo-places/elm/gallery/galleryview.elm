module GalleryView exposing (..)

import Html exposing (Html, div, input, text)
import Html.Attributes exposing (class)
import Msg exposing (Msg(GalleryMsg))
--import GalleryModel exposing (Msg(..))
import Components exposing (topBar)

view : Html Msg.Msg
view = div [ class "gallery-container"] 
        [ topBar [] ]