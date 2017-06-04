module PhotoView exposing (view)

import Html exposing (Html, div, input, text, ul, li, button, span)
import Html.Attributes exposing (class, value, placeholder, classList)
import Html.Events exposing (onInput, onClick)
import Element exposing (toHtml, image)
import Model exposing (Model)
import Photos exposing (getPhotos)
import Suggestion exposing (Suggestion, getDescription)
import Msg exposing (Msg(..))
import Direction exposing (Direction(..))

view : Model -> Html Msg
view model =
  let
    photos = Photos.getPhotos model.photos
    topBarControls =
      div [ class "col-md-12 col-xs-12 row top-bar-controls no-side-pad" ]
        [ secondaryPhotoControls model.showSecondaryControls photos.currentPhotoNumber photos.numberOfPhotos
        , activityIndicator model.isLoading
        , searchElement model.suggestions model.input
        , photoButtons model.input
        , navButtons
        ]
    content = photoElement photos.photoUrl
  in 
    div [ class "top-container" ]
      [ topBar topBarControls
      , content
      ]

topBar : Html Msg -> Html Msg
topBar controls =
  div [ class "top-bar no-side-pad row col-md-12" ] [ controls ]

searchButton : String -> Html Msg
searchButton input =
  button 
    [ class "button search-button col-md-2 col-xs-2", onClick (FreeTextSearch input)] 
    [ span [ class "glyphicon glyphicon-search" ] [] ]

photoButtons : String -> Html Msg
photoButtons userInput =
  div [ class "col-md-2 col-xs-3 photo-button-container" ] 
    [ searchButton userInput
    , switchPhotoButton Left
    , switchPhotoButton Right
    ]

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

photoElement : Maybe String -> Html Msg
photoElement photoUrl =
  let 
    url = 
      case photoUrl of
        Just url -> url
        Nothing -> "" --TODO: Something more sensible
  in
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

secondaryPhotoControls : Bool -> Int -> Int-> Html Msg
secondaryPhotoControls isVisible photoNumber totalPhotos = 
  let
    classes = classList [("row secondary-photo-controls slide", True), ("closed", not isVisible), ("open", isVisible)]
    photoNumberText = "Photo " ++ (toString photoNumber) ++ " / " ++ (toString totalPhotos)
  in  
    div [ classes ] 
      [ div [ class "col-md-12 toggle-button-container" ] [ toggleSecondaryControlsButton isVisible ]
      , div 
        [ classList [("col-md-12 sec-content", True), ("hidden", not isVisible)]] 
        [ text photoNumberText ]
      ]

toggleSecondaryControlsButton : Bool -> Html Msg
toggleSecondaryControlsButton isIconUp =
  let
    iconClasses = classList [("glyphicon glyphicon-chevron-up", isIconUp), ("glyphicon glyphicon-chevron-down", not isIconUp)]
  in
    button 
      [ onClick ToggleSecondaryPhotoControls, class "toggle-sec-controls col-md-2 col-md-offset-5" ] 
      [ span [ iconClasses ] [] ]