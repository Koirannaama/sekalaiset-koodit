module API exposing (..)

import Platform.Cmd exposing (Cmd)
import Http exposing (Error)
import Json.Decode as Dec exposing (int, bool, field, string)
import Json.Encode as Enc exposing (Value, object, string)
import Time exposing (millisecond)

-- Module needs refactoring

type alias Credentials = 
  { username: String
  , password: String
  }

type LoginError = BadCredentials | ServerError

isAuthenticated : (Result Error (Bool, String) -> msg) -> Cmd msg
isAuthenticated msg =
  Http.send msg <|
    Http.request
        { method = "GET"
        , headers = []
        , url = "http://localhost:8000/is_auth" 
        , body = Http.emptyBody
        , expect = Http.expectJson <| Dec.map2 (,) (field "isAuth" bool) (field "token" Dec.string)
        , timeout = Nothing
        , withCredentials = True -- is needed to set cookie with set-cookie-header
        }  

authenticate : Credentials -> String -> (Result Error (Bool, String) -> msg) -> Cmd msg
authenticate creds token msg =
  let
    encodedCreds = Http.jsonBody <| encodeCredentials creds
  in
    Http.send msg <| loginRequest token encodedCreds

encodeCredentials : Credentials -> Value
encodeCredentials creds =
  object 
  [ ("username", Enc.string creds.username)
  , ("password", Enc.string creds.password)
  ]

loginRequest : String -> Http.Body -> Http.Request (Bool, String)
loginRequest token body =
  Http.request  { method = "POST"
                , headers = [ Http.header "X-CSRFToken" token ]
                , url = "http://localhost:8000/login"
                , body = body
                , expect = Http.expectJson <| Dec.map2 (,) (field "isAuth" bool) (field "token" Dec.string)
                , timeout = Just (500*millisecond)
                , withCredentials = True
                }

logout : String -> (Result Error String -> msg) -> Cmd msg
logout token msg =
  Http.send msg <|
    Http.request
        { method = "POST"
        , headers = [ Http.header "X-CSRFToken" token ]
        , url = "http://localhost:8000/logout" 
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = True
        }

getLoginError : Error -> LoginError
getLoginError httpError =
  case httpError of
    Http.BadStatus r -> BadCredentials
    _ -> ServerError

-- Get token from response?
storePhoto : String -> String -> (Result Error String -> msg) -> Cmd msg
storePhoto token photoURL msg =
  let
    body = object [ ("url", Enc.string photoURL) ]
  in
    Http.send msg <|
      Http.request
        { method = "POST"
          , headers = [ Http.header "X-CSRFToken" token ]
          , url = "http://localhost:8000/save_photo" 
          , body = Http.jsonBody body
          , expect = Http.expectString
          , timeout = Nothing
          , withCredentials = True
          }
