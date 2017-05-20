port module Main exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Platform.Sub exposing (Sub, none)
import Navigation exposing (Location)
import Keyboard exposing (KeyCode, presses)
import Model exposing (Model, initModel, setInput, getInput, setSuggestions, flushSuggestions, setPhotoUrls, setChosenSuggestion, nextPhotoUrl, prevPhotoUrl, setRoute)
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
      ((Model.setInput input model), (placeInput input))
    PlaceSuggestions suggs ->
      ((Model.setSuggestions suggs model), Cmd.none)
    PhotoUrls urls ->
      ((Model.setPhotoUrls urls model), Cmd.none)
    SwitchPhoto dir ->
      case dir of
        Right ->
          (Model.nextPhotoUrl model, Cmd.none)
        Left ->
          (Model.prevPhotoUrl model, Cmd.none)
    SelectSuggestion sugg ->
      ((Model.setChosenSuggestion sugg model), (Suggestion.photoCommand getPhotosBySuggestion sugg))
    FreeTextSearch text ->
      ((Model.flushSuggestions model), getPhotosByFreeText text) --Maybe just use getInput here too
    ChangeView location ->
      let
        newRoute = parseLocation location
      in
        ((Model.setRoute newRoute model), Cmd.none)
    KeyPressed code ->
      case code of
        13 -> ((Model.flushSuggestions model), getPhotosByFreeText (Model.getInput model))
        27 -> ((Model.flushSuggestions model), Cmd.none)
        37 -> (Model.prevPhotoUrl model, Cmd.none)
        39 -> (Model.nextPhotoUrl model, Cmd.none)
        _ -> (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch 
    [ photoUrls PhotoUrls
    , placeSuggestions PlaceSuggestions
    , Keyboard.presses KeyPressed
    ]
