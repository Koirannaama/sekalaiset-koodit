module PhotoView exposing (view)

import Html exposing (Html, div, input, text, ul, li, button, span)
import Html.Attributes exposing (class, value, placeholder, classList)
import Html.Events exposing (onInput, onClick)
import Element exposing (toHtml, image)
import Model exposing (Model, getPhotoUrl, getSuggestions, getInput, isLoading, showSecondaryControls)
import Suggestion exposing (Suggestion, getDescription)
import Msg exposing (Msg(..))
import Direction exposing (Direction(..))

view : Model -> Html Msg
view model =
  let
    content = photoElement (Model.getPhotoUrl model)
    suggestions = Model.getSuggestions model
    userInput = Model.getInput model
    isLoading = Model.isLoading model
    showSecondaryControls = Model.showSecondaryControls model
  in 
    div [ class "top-container" ]
      [ topBar suggestions userInput isLoading showSecondaryControls
      , content
      ]

topBar : List Suggestion -> String -> Bool -> Bool -> Html Msg
topBar suggestions userInput isLoading secondaryControlsVisible =
  let
    photoButtons =
      div [ class "col-md-2 col-xs-3 photo-button-container" ] 
        [ searchButton userInput
        , switchPhotoButton Left
        , switchPhotoButton Right
        ]
    controls =
      div [ class "col-md-12 col-xs-12 row top-bar-controls no-side-pad" ]
        [ secondaryPhotoControls secondaryControlsVisible
        , activityIndicator isLoading
        , searchElement suggestions userInput
        , photoButtons
        , navButtons
        ]
  in
    div [ class "top-bar no-side-pad row col-md-12" ] [ controls ]

searchButton : String -> Html Msg
searchButton input =
  button 
    [ class "button search-button col-md-2 col-xs-2", onClick (FreeTextSearch input)] 
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
    button [ class "button col-md-5 col-xs-5", onClick (SwitchPhoto dir) ] [ icon ]

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
    div [ class "col-md-3 col-xs-4 search-element" ] children

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

navButtons : Html Msg
navButtons =
  div [ class "col-md-3 col-xs-4 text-right nav-button-container" ] 
    [ button [ class "button" ] [ text "Search" ]
    , button [ class "button" ] [ text "Gallery" ]
    ]

activityIndicator : Bool -> Html Msg
activityIndicator isVisible =
  let
    activityIndicatorClasses = 
      classList [("hidden", not isVisible), ("float-right activity-indicator", True)]
  in
    div 
      [ class "col-md-4 col-xs-1 activity-indicator-container full-height" ] 
      [ div [ activityIndicatorClasses ] [] ]

secondaryPhotoControls : Bool -> Html Msg
secondaryPhotoControls isVisible = 
  let
    classes = classList [("secondary-photo-controls", True), ("slide-hidden", not isVisible), ("slide-open", isVisible)]
  in  
    div [ classes ] 
      [ button [ onClick ToggleSecondaryPhotoControls ] [ text "Hide" ] 
      , div [ classList [("hidden", not isVisible)]] [ text "dummy content" ]
      ]