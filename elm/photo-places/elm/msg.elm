module Msg exposing (Msg(..))

import Suggestion exposing (Suggestion, RawSuggestion)
import Direction exposing (Direction)

type Msg =
  PlaceInput String
  | PlaceSuggestions (List RawSuggestion)
  | PhotoUrls (List String)
  | SwitchPhoto Direction
  | SelectSuggestion Suggestion