port module Main exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Platform.Sub exposing (Sub, none)
import Navigation exposing (Location)
import Keyboard exposing (KeyCode, presses)
import Model exposing (Model, initModel, flushSuggestions, setChosenSuggestion, toggleSecondaryControls, setSuggestions)
import Photos exposing (Photos, setPhotoUrls, nextPhotoUrl, prevPhotoUrl)
import Suggestion exposing (Suggestion, RawSuggestion, photoCommand)
import Msg exposing (Msg(..))
import Direction exposing (Direction(..))
import View exposing (getView)
import Routing exposing (parseLocation)

port photoUrls : (List String -> msg) -> Sub msg

port placeInput : String -> Cmd msg

port placeSuggestions : (List RawSuggestion -> msg) -> Sub msg

port getPhotosBySuggestion : String -> Cmd msg

port getPhotosByFreeText : String -> Cmd msg

init : Location -> (Model, Cmd Msg)
init loc = 
  let
    currentRoute = Routing.parseLocation loc
  in
    (Model.initModel currentRoute, Cmd.none)

main : Program Never Model Msg
main =
  Navigation.program ChangeView 
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = View.getView
    }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    PlaceInput input ->
      ({ model | input = input }, (placeInput input))
    PlaceSuggestions suggs ->
      ((Model.setSuggestions suggs model), Cmd.none)
    PhotoUrls urls ->
      let
        photos = Photos.setPhotoUrls urls model.photos
      in
        ({ model | photos = photos, isLoading = False, showSecondaryControls = True }, Cmd.none)
    SwitchPhoto dir ->
      let
        photos = 
          case dir of
            Right ->
              Photos.nextPhotoUrl model.photos
            Left ->
              Photos.prevPhotoUrl model.photos
      in
        ({ model | photos = photos }, Cmd.none)      
    SelectSuggestion sugg ->
      ((Model.setChosenSuggestion sugg model), (Suggestion.photoCommand getPhotosBySuggestion sugg))
    FreeTextSearch text ->
      ((Model.flushSuggestions model), getPhotosByFreeText text)
    ChangeView location ->
      let
        newRoute = parseLocation location
      in
        ({ model | route = newRoute }, Cmd.none)
    KeyPressed code ->
      case code of
        13 -> ((Model.flushSuggestions model), getPhotosByFreeText (model.input))
        27 -> ((Model.flushSuggestions model), Cmd.none)
        37 -> ({ model | photos = (Photos.prevPhotoUrl model.photos)}, Cmd.none)
        39 -> ({ model | photos = (Photos.nextPhotoUrl model.photos)}, Cmd.none)
        _ -> (model, Cmd.none)
    ToggleSecondaryPhotoControls ->
      ((Model.toggleSecondaryControls model), Cmd.none)
    SavePhoto url ->
      (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch 
    [ photoUrls PhotoUrls
    , placeSuggestions PlaceSuggestions
    , Keyboard.presses KeyPressed
    ]
