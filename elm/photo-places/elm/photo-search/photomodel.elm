module PhotoModel exposing (Msg(..), Model, update, initModel)

import Keyboard exposing (KeyCode)
import Direction exposing (Direction(..))
import Suggestion exposing (Suggestion, RawSuggestion, getDescription, suggestion)
import Photos exposing (Photos, PhotoData, init, nextPhotoUrl, prevPhotoUrl, getPhotos)
import Ports exposing (..)
import API exposing (APIError, storePhoto)

type Msg =
  PlaceInput String
  | PlaceSuggestions (List RawSuggestion)
  | PhotoUrls (List String)
  | SwitchPhoto Direction
  | SelectSuggestion Suggestion
  | FreeTextSearch String
  | KeyPressed KeyCode
  | ToggleSecondaryPhotoControls
  | StorePhoto String
  | StorePhotoResult (Result APIError String)

type PhotoError = StorePhotoError APIError

type alias Model =
    { input: String
    , suggestions: (List Suggestion)
    , chosenSuggestion: Maybe Suggestion
    , isLoading: Bool
    , showSecondaryControls: Bool
    , photos: Photos
    , error: Maybe PhotoError -- TODO: Show error in view
    }

initModel :  Model 
initModel = 
   { input = ""
   , suggestions = []
   , chosenSuggestion = Nothing
   , isLoading = False
   , showSecondaryControls = False
   , photos = init
   , error = Nothing
   }

update : Msg -> Model -> String -> (Model, Cmd Msg)
update msg model token =
  case msg of
    PlaceInput input ->
      ({ model | input = input }, (placeInput input))
    PlaceSuggestions suggs ->
      ((setSuggestions suggs model), Cmd.none)
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
      ((setChosenSuggestion sugg model), (Suggestion.photoCommand getPhotosBySuggestion sugg))
    FreeTextSearch text ->
      ((flushSuggestions model), getPhotosByFreeText text)
    KeyPressed code ->
      case code of
        13 -> ((flushSuggestions model), getPhotosByFreeText (model.input))
        27 -> ((flushSuggestions model), Cmd.none)
        37 -> ({ model | photos = (Photos.prevPhotoUrl model.photos)}, Cmd.none)
        39 -> ({ model | photos = (Photos.nextPhotoUrl model.photos)}, Cmd.none)
        _ -> (model, Cmd.none)
    ToggleSecondaryPhotoControls ->
      ((toggleSecondaryControls model), Cmd.none)
    StorePhoto url ->
      let
        storeCmd = storePhoto token url StorePhotoResult
      in
        (model, storeCmd)
    StorePhotoResult (Ok _) -> (model, Cmd.none)
    StorePhotoResult (Err err) ->
      ({ model | error = Just <| StorePhotoError err }, Cmd.none)

setSuggestions : List RawSuggestion -> Model -> Model
setSuggestions rawSuggs m =
  let
    suggestions = List.map Suggestion.suggestion rawSuggs
  in
    { m | suggestions = suggestions }

flushSuggestions : Model -> Model
flushSuggestions  m = { m | suggestions = [] }

setChosenSuggestion : Suggestion -> Model -> Model
setChosenSuggestion suggestion m =
  let
    chosenSugg = Just suggestion
  in
     { chosenSuggestion = chosenSugg
     , input = Suggestion.getDescription suggestion
     , suggestions = []
     , isLoading = True
     , showSecondaryControls = m.showSecondaryControls
     , photos = m.photos
     , error = Nothing
     }

toggleSecondaryControls : Model -> Model
toggleSecondaryControls m = { m | showSecondaryControls = not m.showSecondaryControls }