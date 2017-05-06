port module Main exposing (..)

import Html exposing (Html, program, div, input, text, ul, li, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onInput, onClick)
import Platform.Cmd exposing (Cmd, none)
import Platform.Sub exposing (Sub, none)
import Http exposing (header, send, jsonBody, Error, Expect, Body, request, emptyBody, expectJson)
import Debug exposing (log)
import Element exposing (toHtml, image)

port photoUrl : (String -> msg) -> Sub msg

port placeInput : String -> Cmd msg

port placeSuggestions : (List Suggestion -> msg) -> Sub msg

apiKey : String
apiKey = "AIzaSyCKorHiV5ltM3pHvcyPCFrEfh05tTag98Y"

placesAutoCompleteURL : String -> String
placesAutoCompleteURL input =
  "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="
  ++ input
  ++ "&key="
  ++ apiKey

type alias Model = { input: String
                   , suggestions: (List Suggestion)
                   , photoUrl: String }

type alias Suggestion = { id: String
                        , description: String }

type Direction = Left | Right

type Msg =
  PlaceInput String
  | PlaceSuggestions (List Suggestion)
  | PhotoUrl String
  | SwitchPhoto Direction

init : (Model, Cmd Msg)
init = ({ input = "", suggestions = [], photoUrl = "" }, Cmd.none)

main =
  Html.program { init = init,
                 update = update,
                 subscriptions = subscriptions,
                 view = view }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    PlaceInput input ->
      ({ model | input = input }, (placeInput input))
    PlaceSuggestions suggs ->
      ({ model | suggestions = suggs }, Cmd.none)
    PhotoUrl url ->
      ({ model | photoUrl = url }, Cmd.none)
    SwitchPhoto dir ->
      (model, Cmd.none)

view : Model -> Html Msg
view model =
  div [ class "top-container" ]
    [ topBar model.suggestions
    , photoElement model.photoUrl
    ]

topBar : List Suggestion -> Html Msg
topBar suggestions =
  let
    controls =
      div [ class "top-bar-controls col-md-4 col-md-offset-4" ]
        [ searchElement suggestions
        , button [ class "button col-md-2 col-xs-2", onClick (SwitchPhoto Left) ] [ text "L" ]
        , button [ class "button col-md-2 col-xs-2", onClick (SwitchPhoto Right) ] [ text "R"]
        ]
  in
    div [ class "top-bar row col-md-12" ] [ controls ]

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
    listItems = List.map (\s -> li [] [ text s.description ]) suggs
  in
    ul [ class "suggestions place-input-element" ] listItems

photoElement : String -> Html Msg
photoElement url =
  Element.image 1000 1000 url
  |> Element.toHtml

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ photoUrl PhotoUrl,  placeSuggestions PlaceSuggestions]
