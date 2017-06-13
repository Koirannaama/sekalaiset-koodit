module Msg exposing (Msg(..))

import Navigation exposing (Location)
import PhotoModel exposing (Msg)

type Msg =
  PhotoMsg PhotoModel.Msg
  | ChangeView Location
  | SavePhoto String