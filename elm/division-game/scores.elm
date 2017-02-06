module Scores exposing (getHighScores)

import Http exposing (send, getString, Error, request, emptyBody, expectString)
import Json.Decode as Decode
import Global exposing (Msg)
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
                   , expect = Http.expectString --vaihda JSONiin kun tulee oikeeta dataa
                   , timeout = Just (500*millisecond)
                   , withCredentials = False
                   }
  in
    Http.send processResult request

processResult : Result Http.Error String -> Msg
processResult result =
  case result of
    Ok scores ->
      Global.HighScores [(scores, 1)]
    Err _ ->
      Global.HighScores [("Error", 1)]

parseScores : Decode.Decoder String
parseScores =
  Decode.string
