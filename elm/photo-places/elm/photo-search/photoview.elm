module PhotoView exposing (view)

import Html exposing (Html, div, input, text, ul, li, button, span, form)
import Html.Attributes exposing (class, value, placeholder, classList, href, action)
import Html.Events exposing (onInput, onClick)
import Element exposing (toHtml, image)
import Photos exposing (getPhotos)
import Suggestion exposing (Suggestion, getDescription)
import Msg exposing (Msg(..))
import PhotoModel exposing (Model, Msg(..))
import Direction exposing (Direction(..))
import Routing exposing (galleryPath, photoPath)
import Components exposing (iconButton)

view : Model -> Html Msg.Msg
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

topBar : Html Msg.Msg -> Html Msg.Msg
topBar controls =
  div [ class "top-bar no-side-pad row col-md-12" ] [ controls ]

searchButton : String -> Html Msg.Msg
searchButton input =
  iconButton
    [ class "button search-button col-md-2 col-xs-2"
    , onClick (PhotoMsg (FreeTextSearch input)) ]
    (class "glyphicon glyphicon-search")

photoButtons : String -> Html Msg.Msg
photoButtons userInput =
  div [ class "col-md-2 col-xs-3 photo-button-container" ] 
    [ searchButton userInput
    , switchPhotoButton Left
    , switchPhotoButton Right
    ]

switchPhotoButton : Direction -> Html Msg.Msg
switchPhotoButton dir =
  let
    iconClass =
      case dir of
        Left -> "glyphicon glyphicon-arrow-left"
        Right -> "glyphicon glyphicon-arrow-right"
  in
    iconButton 
      [ class "button col-md-5 col-xs-5", onClick (PhotoMsg (SwitchPhoto dir)) ]
      (class iconClass)

searchElement : List Suggestion -> String -> Html Msg.Msg
searchElement suggestions userInput =
  let
    inputBox =
      input [ class "input-box place-input-element"
            , onInput (\s -> PhotoMsg (PlaceInput s))
            , value userInput
            , placeholder "Search for location" ] []
    children =
      case suggestions of
        [] -> [inputBox]
        ss -> [inputBox, (suggestionDisplay ss)]
  in
    div [ class "col-md-3 col-xs-4 search-element" ] children

suggestionDisplay : List Suggestion -> Html Msg.Msg
suggestionDisplay suggs =
  let
    listItem suggestion =
      li [ onClick (PhotoMsg (SelectSuggestion suggestion)) ] 
         [ text (Suggestion.getDescription suggestion) ]
    listItems = List.map listItem suggs
  in
    ul [ class "suggestions place-input-element" ] listItems

photoElement : Maybe String -> Html Msg.Msg
photoElement photoUrl =
  let 
    url = 
      case photoUrl of
        Just url -> url
        Nothing -> "" --TODO: Something more sensible
  in
    Element.image 1000 1000 url
    |> Element.toHtml

navButtons : Html Msg.Msg
navButtons =
  div [ class "col-md-3 col-xs-4 text-right nav-button-container" ] 
    -- TODO: replace forms with links
    [ form [ class "nav-form", action photoPath] [button [ class "button" ] [ text "Search" ]]
    , form [ class "nav-form", action galleryPath] [button [ class "button" ] [ text "Gallery" ]]
    ]

activityIndicator : Bool -> Html Msg.Msg
activityIndicator isVisible =
  let
    activityIndicatorClasses = 
      classList [("hidden", not isVisible), ("float-right activity-indicator", True)]
  in
    div 
      [ class "col-md-4 col-xs-1 activity-indicator-container full-height" ] 
      [ div [ activityIndicatorClasses ] [] ]

secondaryPhotoControls : Bool -> Int -> Int-> String -> Html Msg.Msg
secondaryPhotoControls isVisible photoNumber totalPhotos photoUrl = 
  let
    classes = classList [("row secondary-photo-controls slide", True), ("closed", not isVisible), ("open", isVisible)]
  in  
    div [ classes ] 
      [ div [ class "row col-md-12 toggle-button-container" ] 
          [ toggleSecondaryControlsButton isVisible ]
      , div [ classList [("row col-md-12 sec-content", True), ("hidden", not isVisible)]] 
          [ photoNumberLabel photoNumber totalPhotos
          , saveToGalleryButton photoUrl
          , downloadButton ]
      ]

photoNumberLabel : Int -> Int -> Html Msg.Msg
photoNumberLabel current total =
  let
    numberText = "Photo " ++ (toString current) ++ " / " ++ (toString total)
  in
    div [ class "col-md-3 number-label-container full-height" ] [
      span [ class "number-label" ] [ text numberText ] 
    ]

toggleSecondaryControlsButton : Bool -> Html Msg.Msg
toggleSecondaryControlsButton isIconUp =
  let
    iconClasses = classList [("glyphicon glyphicon-chevron-up", isIconUp), ("glyphicon glyphicon-chevron-down", not isIconUp)]
  in
    iconButton
      [ onClick (PhotoMsg ToggleSecondaryPhotoControls)
      , class "toggle-sec-controls col-md-2 col-md-offset-5" ]
      iconClasses

saveToGalleryButton : String -> Html Msg.Msg
saveToGalleryButton photoUrl =
  iconButton
    [ class "col-md-1 button btn-secondary", onClick (SavePhoto photoUrl) ]
    (class "glyphicon glyphicon-floppy-disk")

downloadButton : Html Msg.Msg
downloadButton =
  iconButton 
    [ class "col-md-1 button btn-secondary" ] 
    (class "glyphicon glyphicon-download-alt")