module Model exposing (Model, getSuggestions, initModel, setInput, setSuggestions, setPhotoUrls
                      , getPhotoUrl, setChosenSuggestion, getInput, nextPhotoUrl, prevPhotoUrl)

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

firstToLast : List a -> List a
firstToLast list =
  case list of
    [] -> []
    [x] -> [x]
    x::xs -> List.append xs [x]

lastToFirst : List a -> List a
lastToFirst list =
  case List.reverse list of
    [] -> []
    [x] -> [x]
    x::xs -> x :: (List.reverse xs)

nextPhotoUrl : Model -> Model
nextPhotoUrl ((Model m) as model) =
  firstToLast m.photoUrls |> (flip setPhotoUrls) model

prevPhotoUrl : Model -> Model
prevPhotoUrl ((Model m) as model) =
  lastToFirst m.photoUrls |> (flip setPhotoUrls) model    
