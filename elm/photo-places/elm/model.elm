module Model exposing (..)

import PhotoModel exposing (Model, initModel)
import GalleryModel exposing (Model, initModel)

type alias Model =
  { photoModel: PhotoModel.Model
  , galleryModel: GalleryModel.Model
  , route: Route
  , navMenuOpen: Bool
  }

type Route =
  PhotoRoute
  | GalleryRoute
  | NotFoundRoute

initModel : Route -> Model 
initModel route = 
   { photoModel = PhotoModel.initModel
   , galleryModel = GalleryModel.initModel
   , route = route
   , navMenuOpen = False
   }
