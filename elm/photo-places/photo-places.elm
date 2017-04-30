port module Main exposing (..)

import Html exposing (Html, program, div, input, text, ul, li)
import Html.Events exposing (onInput)
import Platform.Cmd exposing (Cmd, none)
import Platform.Sub exposing (Sub, none)
import Http exposing (header, send, jsonBody, Error, Expect, Body, request, emptyBody, expectJson)
import Json.Decode as Decode exposing (keyValuePairs, int, field, map)
import Time exposing (millisecond, Time)
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

type Msg =
  PlaceInput String
  | PlaceSuggestions (List Suggestion)
  | PhotoUrl String


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

view : Model -> Html Msg
view model =
  div []
    [ (input [ onInput PlaceInput] [])
    , (suggestionDisplay model.suggestions)
    , (photoElement model.photoUrl)
    ]

suggestionDisplay : List Suggestion -> Html Msg
suggestionDisplay suggs =
  let
    listItems = List.map (\s -> li [] [ text s.description ]) suggs
  in
    ul [] listItems

photoElement : String -> Html Msg
photoElement url =
  Element.image 1000 1000 url
  |> Element.toHtml

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ photoUrl PhotoUrl,  placeSuggestions PlaceSuggestions]
