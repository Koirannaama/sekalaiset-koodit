port module Main exposing (..)

import Html exposing (Html, program, div, input, text, ul, li, button, span)
import Html.Attributes exposing (class, value, placeholder)
import Html.Events exposing (onInput, onClick)
import Platform.Cmd exposing (Cmd, none)
import Platform.Sub exposing (Sub, none)
import Element exposing (toHtml, image)
import Model exposing (Model, initModel, setInput, setSuggestions, setPhotoUrls, getPhotoUrl, setChosenSuggestion, getInput, nextPhotoUrl, prevPhotoUrl)
import Suggestion exposing (Suggestion, RawSuggestion, getDescription, photoCommand)

port photoUrls : (List String -> msg) -> Sub msg

port placeInput : String -> Cmd msg

port placeSuggestions : (List RawSuggestion -> msg) -> Sub msg

port getPhotos : String -> Cmd msg

type Direction = Left | Right

type Msg =
  PlaceInput String
  | PlaceSuggestions (List RawSuggestion)
  | PhotoUrls (List String)
  | SwitchPhoto Direction
  | SelectSuggestion Suggestion

init : (Model, Cmd Msg)
init = (Model.initModel, Cmd.none)

main : Program Never Model Msg
main =
  Html.program { init = init,
                 update = update,
                 subscriptions = subscriptions,
                 view = view }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    PlaceInput input ->
      ((Model.setInput input model), (placeInput input))
    PlaceSuggestions suggs ->
      ((Model.setSuggestions suggs model), Cmd.none)
    PhotoUrls urls ->
      ((Model.setPhotoUrls urls model), Cmd.none)
    SwitchPhoto dir ->
      case dir of
        Right ->
          (Model.nextPhotoUrl model, Cmd.none)
        Left ->
          (Model.prevPhotoUrl model, Cmd.none)
    SelectSuggestion sugg ->
      ((Model.setChosenSuggestion sugg model), (Suggestion.photoCommand getPhotos sugg))


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

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ photoUrls PhotoUrls,  placeSuggestions PlaceSuggestions]
