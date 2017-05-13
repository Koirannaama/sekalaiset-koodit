module Msg exposing (Msg(..))

import Suggestion exposing (Suggestion, RawSuggestion)
import Direction exposing (Direction)
import Navigation exposing (Location)

type Msg =
  PlaceInput String
  | PlaceSuggestions (List RawSuggestion)
  | PhotoUrls (List String)
  | SwitchPhoto Direction
  | SelectSuggestion Suggestion
  | ChangeView Location