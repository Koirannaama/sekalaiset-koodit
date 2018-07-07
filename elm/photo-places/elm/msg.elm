module Msg exposing (Msg(..))

import Navigation exposing (Location)
import PhotoModel exposing (Msg)
import GalleryModel exposing (Msg)
import LoginMsg exposing (Msg)
import Result
import Http

type Msg =
  PhotoMsg PhotoModel.Msg
  | GalleryMsg GalleryModel.Msg
  | LoginMsg LoginMsg.Msg
  | ChangeView Location
  | ToggleNavMenu
  | IsAuthenticated (Result Http.Error (Bool, String))
  | KeyPressed Int
  | LoginSuccess