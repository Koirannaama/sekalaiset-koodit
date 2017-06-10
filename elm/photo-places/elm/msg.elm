module Msg exposing (Msg(..))

import Suggestion exposing (Suggestion, RawSuggestion)
import Keyboard exposing (KeyCode)
import Navigation exposing (Location)
import Direction exposing (Direction)


type Msg =
  PlaceInput String
  | PlaceSuggestions (List RawSuggestion)
  | PhotoUrls (List String)
  | SwitchPhoto Direction
  | SelectSuggestion Suggestion
  | FreeTextSearch String
  | ChangeView Location
  | KeyPressed KeyCode
  | ToggleSecondaryPhotoControls
  | SavePhoto String