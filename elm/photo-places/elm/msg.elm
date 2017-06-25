module Msg exposing (Msg(..))

import Navigation exposing (Location)
import PhotoModel exposing (Msg)
import GalleryModel exposing (Msg)

type Msg =
  PhotoMsg PhotoModel.Msg
  | ChangeView Location
  | GalleryMsg GalleryModel.Msg
  | ToggleNavMenu