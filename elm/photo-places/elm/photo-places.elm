port module Main exposing (..)

import Platform.Cmd exposing (Cmd, none, map)
import Platform.Sub exposing (Sub, none)
import Navigation exposing (Location)
import Keyboard exposing (KeyCode, presses)
import Model exposing (Model)
import Msg exposing (Msg(..))
import View exposing (getView)
import Routing exposing (parseLocation)
import Ports exposing (..)
import PhotoModel exposing (update, Msg(PhotoUrls, PlaceSuggestions, KeyPressed))
import GalleryModel exposing (update)

init : Location -> (Model, Cmd Msg.Msg)
init loc = 
  let
    currentRoute = Routing.parseLocation loc
  in
    (Model.initModel currentRoute, Cmd.none)

main : Program Never Model Msg.Msg
main =
  Navigation.program ChangeView 
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = View.getView
    }

update : Msg.Msg -> Model -> (Model, Cmd Msg.Msg)
update msg model =
  case msg of
    PhotoMsg photoMsg ->
      let
        (newPhotoModel, cmd) = PhotoModel.update photoMsg model.photoModel
      in
        ({ model | photoModel = newPhotoModel}, (Cmd.map PhotoMsg cmd))
    GalleryMsg galleryMsg ->
      let
        (newGalleryModel, cmd) = GalleryModel.update galleryMsg model.galleryModel
      in
        ({ model | galleryModel = newGalleryModel}, (Cmd.map GalleryMsg cmd))
    ChangeView location ->
      let
        newRoute = parseLocation location
      in
        ({ model | route = newRoute }, Cmd.none)

subscriptions : Model -> Sub Msg.Msg
subscriptions model =
  Sub.batch 
    [ photoUrls (PhotoUrls >> PhotoMsg)
    , placeSuggestions (PlaceSuggestions >> PhotoMsg)
    , Keyboard.presses (KeyPressed >> PhotoMsg)
    ]
