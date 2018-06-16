module Msg exposing (Msg(..))

import Navigation exposing (Location)
import PhotoModel exposing (Msg)
import GalleryModel exposing (Msg)
import LoginModel exposing (Msg)
import Result
import Http

type Msg =
  PhotoMsg PhotoModel.Msg
  | GalleryMsg GalleryModel.Msg
  | LoginMsg LoginModel.Msg
  | ChangeView Location
  | ToggleNavMenu
  | IsAuthenticated (Result Http.Error Bool)