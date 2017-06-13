port module Ports exposing (..)

import Suggestion exposing (RawSuggestion)

port photoUrls : (List String -> msg) -> Sub msg

port placeInput : String -> Cmd msg

port placeSuggestions : (List RawSuggestion -> msg) -> Sub msg

port getPhotosBySuggestion : String -> Cmd msg

port getPhotosByFreeText : String -> Cmd msg