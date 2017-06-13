module Model exposing (..)

import Suggestion exposing (Suggestion, RawSuggestion, getDescription, suggestion)
import Photos exposing (Photos, PhotoData, init, nextPhotoUrl, prevPhotoUrl, getPhotos)
import PhotoModel exposing (Model, initModel)

type alias Model =
  { photoModel: PhotoModel.Model
  , route: Route
  }

type Route =
  PhotoRoute
  | GalleryRoute
  | NotFoundRoute

initModel : Route -> Model 
initModel route = 
   { photoModel = PhotoModel.initModel
   , route = route
   }
