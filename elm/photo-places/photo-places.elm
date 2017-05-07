port module Main exposing (..)

import Html exposing (Html, program, div, input, text, ul, li, button, span)
import Html.Attributes exposing (class)
import Html.Events exposing (onInput, onClick)
import Platform.Cmd exposing (Cmd, none)
import Platform.Sub exposing (Sub, none)
import Element exposing (toHtml, image)
import Model exposing (Model, Suggestion, RawSuggestion, getSuggestionDescription, getSuggestions
                      , initModel, setInput, setSuggestions, setPhotoUrls, getPhotoUrl)

port photoUrls : (List String -> msg) -> Sub msg

port placeInput : String -> Cmd msg

port placeSuggestions : (List RawSuggestion -> msg) -> Sub msg

type Direction = Left | Right

type Msg =
  PlaceInput String
  | PlaceSuggestions (List RawSuggestion)
  | PhotoUrls (List String)
  | SwitchPhoto Direction

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
      (model, Cmd.none)

view : Model -> Html Msg
view model =
  let
    content = photoElement (Model.getPhotoUrl model)
  in 
    div [ class "top-container" ]
      [ topBar (Model.getSuggestions model)
      , content
      ]

topBar : List Suggestion -> Html Msg
topBar suggestions =
  let
    controls =
      div [ class "top-bar-controls col-md-4 col-md-offset-4" ]
        [ searchElement suggestions
        , switchPhotoButton Left
        , switchPhotoButton Right
        ]
  in
    div [ class "top-bar row col-md-12" ] [ controls ]

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

searchElement : List Suggestion -> Html Msg
searchElement suggestions =
  let
    inputBox =
      input [ class "input-box place-input-element"
            , onInput PlaceInput] []
    children =
      case suggestions of
        [] -> [inputBox]
        ss -> [inputBox, (suggestionDisplay ss)]
  in
    div [ class "search-element col-md-8 col-xs-8" ] children

suggestionDisplay : List Suggestion -> Html Msg
suggestionDisplay suggs =
  let
    listItems = List.map (\s -> li [] [ text (Model.getSuggestionDescription s) ]) suggs
  in
    ul [ class "suggestions place-input-element" ] listItems

photoElement : String -> Html Msg
photoElement url =
  Element.image 1000 1000 url
  |> Element.toHtml

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ photoUrls PhotoUrls,  placeSuggestions PlaceSuggestions]
