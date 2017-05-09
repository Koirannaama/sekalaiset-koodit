module Model exposing (Model, getSuggestions, initModel, setInput, setSuggestions, setPhotoUrls
                      , getPhotoUrl, setChosenSuggestion, getInput)

import Suggestion exposing (Suggestion, RawSuggestion, getDescription, suggestion)

type Model 
    = Model { input: String
            , suggestions: (List Suggestion)
            , photoUrls: List String
            , chosenSuggestion: Maybe Suggestion
            }

getSuggestions : Model -> List Suggestion
getSuggestions (Model m) = m.suggestions

initModel : Model 
initModel = Model { input = "", suggestions = [], photoUrls = [], chosenSuggestion = Nothing }

setInput : String -> Model -> Model
setInput input (Model m) = 
  Model { m | input = input }

getInput : Model -> String
getInput (Model m) =
  m.input

setSuggestions : List RawSuggestion -> Model -> Model
setSuggestions rawSuggs (Model m) =
  let
    suggestions = List.map Suggestion.suggestion rawSuggs
  in
    Model { m | suggestions = suggestions }

setPhotoUrls : List String -> Model -> Model
setPhotoUrls urls (Model m) =
  Model { m | photoUrls = urls }

getPhotoUrl : Model -> String
getPhotoUrl (Model m) =
  case List.head m.photoUrls of
    Just url -> url
    Nothing -> "" --TODO: doesn't make sense yet

setChosenSuggestion : Suggestion -> Model -> Model
setChosenSuggestion suggestion (Model m) =
  let
    chosenSugg = Just suggestion
  in
    Model { chosenSuggestion = chosenSugg
          , input = Suggestion.getDescription suggestion
          , photoUrls = []
          , suggestions = []
          }