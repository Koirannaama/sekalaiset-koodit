module API exposing (..)

import Msg exposing (Msg(..))
import Platform.Cmd exposing (Cmd)
import Http
import Json.Decode exposing (int, bool, field)

isAuthenticated : Cmd Msg.Msg
isAuthenticated =
  Http.send IsAuthenticated <|
    Http.get "http://localhost:8000/is_auth" (field "isAuth" bool)
