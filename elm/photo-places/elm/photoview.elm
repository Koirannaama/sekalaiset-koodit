module PhotoView exposing (view)

import Html exposing (Html, div, input, text, ul, li, button, span)
import Html.Attributes exposing (class, value, placeholder)
import Html.Events exposing (onInput, onClick)
import Element exposing (toHtml, image)
import Model exposing (Model, getPhotoUrl, getSuggestions, getInput)
import Suggestion exposing (Suggestion, getDescription)
import Msg exposing (Msg(..))
import Direction exposing (Direction(..))

view : Model -> Html Msg
view model =
  let
    content = photoElement (Model.getPhotoUrl model)
    suggestions = Model.getSuggestions model
    userInput = Model.getInput model
  in 
    div [ class "top-container" ]
      [ topBar suggestions userInput
      , content
      ]

topBar : List Suggestion -> String -> Html Msg
topBar suggestions userInput =
  let
    controls =
      div [ class "top-bar-controls col-md-4 col-md-offset-4" ]
        [ searchElement suggestions userInput
        , searchButton --TODO: doesn't do anything yet
        , switchPhotoButton Left
        , switchPhotoButton Right
        ]
  in
    div [ class "top-bar row col-md-12" ] [ controls ]

searchButton : Html Msg
searchButton =
  button 
    [ class "button search-button col-md-1 col-xs-1"] 
    [ span [ class "glyphicon glyphicon-search" ] [] ]

switchPhotoButton : Direction -> Html Msg
switchPhotoButton dir =
  let
    iconClass =
      case dir of
        Left -> "glyphicon glyphicon-arrow-left"
        Right -> "glyphicon glyphicon-arrow-right"
    icon = span [ class iconClass ] []
  in
    button [ class "button col-md-2 col-xs-2", onClick (SwitchPhoto dir) ] [ icon ]

searchElement : List Suggestion -> String -> Html Msg
searchElement suggestions userInput =
  let
    inputBox =
      input [ class "input-box place-input-element"
            , onInput PlaceInput
            , value userInput
            , placeholder "Search for location" ] []
    children =
      case suggestions of
        [] -> [inputBox]
        ss -> [inputBox, (suggestionDisplay ss)]
  in
    div [ class "search-element col-md-7 col-xs-7" ] children

suggestionDisplay : List Suggestion -> Html Msg
suggestionDisplay suggs =
  let
    listItem suggestion =
      li [ onClick (SelectSuggestion suggestion) ] 
         [ text (Suggestion.getDescription suggestion) ]
    listItems = List.map listItem suggs
  in
    ul [ class "suggestions place-input-element" ] listItems

photoElement : String -> Html Msg
photoElement url =
  Element.image 1000 1000 url
  |> Element.toHtml