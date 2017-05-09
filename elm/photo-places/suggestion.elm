module Suggestion exposing (Suggestion, RawSuggestion, getDescription, suggestion, photoCommand)

type Suggestion 
    = Suggestion { id: String
                 , description: String 
                 } 

type alias RawSuggestion = { id: String
                           , description: String }

getDescription : Suggestion -> String
getDescription (Suggestion s) = s.description

suggestion : RawSuggestion -> Suggestion
suggestion raw = Suggestion raw

photoCommand : (String -> Cmd msg) -> Suggestion -> Cmd msg
photoCommand portFunc (Suggestion s) =
  portFunc s.id