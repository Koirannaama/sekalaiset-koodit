module Scores exposing (getHighScores)

import Http exposing (send, getString, Error, request, emptyBody, expectString, expectJson)
import Json.Decode as Decode exposing (keyValuePairs, int, field, map)
import Global exposing (Msg, Score)
import Debug exposing (log)
import Time exposing (millisecond, Time)

getHighScores : Cmd Msg
getHighScores =
  let
    request =
      Http.request { method = "GET"
                   , headers = []
                   , url = "http://localhost:8081"
                   , body = Http.emptyBody
                   , expect = Http.expectJson parseScores
                   , timeout = Just (500*millisecond)
                   , withCredentials = False
                   }
  in
    Http.send processResult request

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
