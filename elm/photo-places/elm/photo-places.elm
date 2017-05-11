port module Main exposing (..)

import Html exposing (Html, program)
import Platform.Cmd exposing (Cmd, none)
import Platform.Sub exposing (Sub, none)
import Model exposing (Model, initModel, setInput, setSuggestions, setPhotoUrls, setChosenSuggestion, nextPhotoUrl, prevPhotoUrl)
import Suggestion exposing (Suggestion, RawSuggestion, photoCommand)
import Msg exposing (Msg(..))
import Direction exposing (Direction(..))
import PhotoView exposing (view)

port photoUrls : (List String -> msg) -> Sub msg

port placeInput : String -> Cmd msg

port placeSuggestions : (List RawSuggestion -> msg) -> Sub msg

port getPhotos : String -> Cmd msg

init : (Model, Cmd Msg)
init = (Model.initModel, Cmd.none)

main : Program Never Model Msg
main =
  Html.program { init = init,
                 update = update,
                 subscriptions = subscriptions,
                 view = PhotoView.view }

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
      ((Model.setChosenSuggestion sugg model), (Suggestion.photoCommand getPhotos sugg))

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ photoUrls PhotoUrls,  placeSuggestions PlaceSuggestions]
