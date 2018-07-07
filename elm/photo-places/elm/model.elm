module Model exposing (..)

import PhotoModel exposing (Model, initModel)
import GalleryModel exposing (Model, initModel)
import LoginModel exposing (Model, initModel)

type alias Model =
  { photoModel: PhotoModel.Model
  , galleryModel: GalleryModel.Model
  , loginModel: LoginModel.Model
  , route: Route
  , navMenuOpen: Bool
  , csrfToken: String
  }

type Route =
  PhotoRoute
  | GalleryRoute
  | NotFoundRoute

initModel : Route -> Model 
initModel route = 
   { photoModel = PhotoModel.initModel
   , galleryModel = GalleryModel.initModel
   , loginModel = LoginModel.initModel
   , route = route
   , navMenuOpen = False
   , csrfToken = ""
   }

isLoginVisible : Model -> Bool
isLoginVisible model =
  LoginModel.isLoginVisible model.loginModel