module Scores exposing (getHighScores)

import Http exposing (send, getString, jsonBody, Error, Expect, Body, request, emptyBody, expectJson)
import Json.Decode as Decode exposing (keyValuePairs, int, field, map)
import Json.Encode as Encode exposing (int, object, Value)
import Global exposing (Msg, Score)
import Debug exposing (log)
import Time exposing (millisecond, Time)

createRequest : Http.Body -> String -> Http.Request (List Score)
createRequest body method =
  let
    jsonExp = Http.expectJson parseScores
  in
    Http.request { method = method
                 , headers = []
                 , url = "http://localhost:8081"
                 , body = body
                 , expect = jsonExp
                 , timeout = Just (500*millisecond)
                 , withCredentials = False
                 }

postRequest : Score -> Http.Request (List Score)
postRequest score =
  let
    encodedScore = scoreToJson score
    requestBody = Http.jsonBody encodedScore
  in
    createRequest requestBody "POST"

getRequest : Http.Request (List Score)
getRequest =
    createRequest Http.emptyBody "GET"

getHighScores : Cmd Msg
getHighScores =
   Http.send processResult getRequest

processResult : Result Http.Error (List Score) -> Msg
processResult result =
  case result of
    Ok scores ->
      Global.HighScores scores
    Err _ ->
      Global.HighScores []

parseScores : Decode.Decoder (List Score)
parseScores =
    Decode.field "scores" (Decode.list (Decode.keyValuePairs Decode.int))
    |> Decode.map List.concat

scoreToJson : Score -> Encode.Value
scoreToJson (name, points) =
  Encode.object [ (name, (Encode.int points)) ]
