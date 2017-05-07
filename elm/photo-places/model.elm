module Model exposing (Model, Suggestion, RawSuggestion, getSuggestionDescription, getSuggestions
                      , initModel, setInput, setSuggestions, setPhotoUrls, getPhotoUrl)

type Model 
    = Model { input: String
            , suggestions: (List Suggestion)
            , photoUrls: List String 
            }

type Suggestion 
    = Suggestion { id: String
                 , description: String 
                 } 

type alias RawSuggestion = { id: String
                           , description: String }

getSuggestionDescription : Suggestion -> String
getSuggestionDescription (Suggestion s) = s.description

getSuggestions : Model -> List Suggestion
getSuggestions (Model m) = m.suggestions

initModel : Model 
initModel = Model { input = "", suggestions = [], photoUrls = [] }

setInput : String -> Model -> Model
setInput input (Model m) = 
  Model { m | input = input }

setSuggestions : List RawSuggestion -> Model -> Model
setSuggestions rawSuggs (Model m) =
  let
    suggestions = List.map Suggestion rawSuggs
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