module Model exposing (Model, Route(..), initModel, flushSuggestions, setChosenSuggestion, setSuggestions, toggleSecondaryControls)

import Suggestion exposing (Suggestion, RawSuggestion, getDescription, suggestion)
import Photos exposing (Photos, PhotoData, init, nextPhotoUrl, prevPhotoUrl, getPhotos)

type alias Model =
    { input: String
    , suggestions: (List Suggestion)
    , chosenSuggestion: Maybe Suggestion
    , route: Route
    , isLoading: Bool
    , showSecondaryControls: Bool
    , photos: Photos
    }

type Route =
  PhotoRoute
  | GalleryRoute
  | NotFoundRoute

initModel : Route -> Model 
initModel route = 
   { input = ""
        , suggestions = []
        , chosenSuggestion = Nothing
        , route = route
        , isLoading = False
        , showSecondaryControls = False
        , photos = init
        }

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
          , route = m.route
          , isLoading = True
          , showSecondaryControls = m.showSecondaryControls
          , photos = m.photos
          }

toggleSecondaryControls : Model -> Model
toggleSecondaryControls m = { m | showSecondaryControls = not m.showSecondaryControls }
