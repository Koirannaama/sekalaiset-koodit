module PhotoModel exposing (Msg(..), Model, update, initModel)

import Keyboard exposing (KeyCode)
import Direction exposing (Direction(..))
import Suggestion exposing (Suggestion, RawSuggestion, getDescription, suggestion)
import Photos exposing (Photos, PhotoData, init, nextPhotoUrl, prevPhotoUrl, getPhotos)
import Ports exposing (..)

type Msg =
  PlaceInput String
  | PlaceSuggestions (List RawSuggestion)
  | PhotoUrls (List String)
  | SwitchPhoto Direction
  | SelectSuggestion Suggestion
  | FreeTextSearch String
  | KeyPressed KeyCode
  | ToggleSecondaryPhotoControls

type alias Model =
    { input: String
    , suggestions: (List Suggestion)
    , chosenSuggestion: Maybe Suggestion
    , isLoading: Bool
    , showSecondaryControls: Bool
    , photos: Photos
    }

initModel :  Model 
initModel = 
   { input = ""
   , suggestions = []
   , chosenSuggestion = Nothing
   , isLoading = False
   , showSecondaryControls = False
   , photos = init
   }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
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
     }

toggleSecondaryControls : Model -> Model
toggleSecondaryControls m = { m | showSecondaryControls = not m.showSecondaryControls }