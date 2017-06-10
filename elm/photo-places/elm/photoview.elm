module PhotoView exposing (view)

import Html exposing (Html, div, input, text, ul, li, button, span, form)
import Html.Attributes exposing (class, value, placeholder, classList, href, action)
import Html.Events exposing (onInput, onClick)
import Element exposing (toHtml, image)
import Model exposing (Model)
import Photos exposing (getPhotos)
import Suggestion exposing (Suggestion, getDescription)
import Msg exposing (Msg(..))
import Direction exposing (Direction(..))
import Routing exposing (galleryPath, photoPath)

view : Model -> Html Msg
view model =
  let
    photos = Photos.getPhotos model.photos
    toBarControlContainer = div [ class "col-md-12 col-xs-12 row top-bar-controls no-side-pad" ]
    topBarControlElements = 
      [ activityIndicator model.isLoading
      , searchElement model.suggestions model.input
      , photoButtons model.input
      , navButtons
      ]
    topBarControls = 
      case photos.photoUrl of 
        Just url -> 
          toBarControlContainer 
            (secondaryPhotoControls model.showSecondaryControls photos.currentPhotoNumber photos.numberOfPhotos model.input
            :: topBarControlElements)
        Nothing -> toBarControlContainer topBarControlElements
  in 
    div [ class "top-container" ]
      [ topBar topBarControls
      , photoElement photos.photoUrl
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
    -- TODO: replace forms with links
    [ form [ class "nav-form", action photoPath] [button [ class "button" ] [ text "Search" ]]
    , form [ class "nav-form", action galleryPath] [button [ class "button" ] [ text "Gallery" ]]
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

secondaryPhotoControls : Bool -> Int -> Int-> String -> Html Msg
secondaryPhotoControls isVisible photoNumber totalPhotos photoUrl = 
  let
    classes = classList [("row secondary-photo-controls slide", True), ("closed", not isVisible), ("open", isVisible)]
    photoNumberText = "Photo " ++ (toString photoNumber) ++ " / " ++ (toString totalPhotos)
  in  
    div [ classes ] 
      [ div [ class "row col-md-12 toggle-button-container" ] [ toggleSecondaryControlsButton isVisible ]
      , div [ classList [("row col-md-12 sec-content", True), ("hidden", not isVisible)]] 
          [ span [ class "col-md-3" ] [ text photoNumberText ]
          , saveToGalleryButton photoUrl
          , downloadButton ]
      ]

toggleSecondaryControlsButton : Bool -> Html Msg
toggleSecondaryControlsButton isIconUp =
  let
    iconClasses = classList [("glyphicon glyphicon-chevron-up", isIconUp), ("glyphicon glyphicon-chevron-down", not isIconUp)]
  in
    button 
      [ onClick ToggleSecondaryPhotoControls, class "toggle-sec-controls col-md-2 col-md-offset-5" ] 
      [ span [ iconClasses ] [] ]

saveToGalleryButton : String -> Html Msg
saveToGalleryButton photoUrl = 
  button [ class "col-md-1 button btn-secondary", onClick (SavePhoto photoUrl) ] 
    [ span [ class "glyphicon glyphicon-floppy-disk" ] [] ]

downloadButton : Html Msg
downloadButton =
  button [ class "col-md-1 button btn-secondary" ] 
    [ span [ class "glyphicon glyphicon-download-alt" ] [] ]