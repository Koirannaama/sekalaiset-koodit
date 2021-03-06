module API exposing (..)

import Platform.Cmd exposing (Cmd)
import Http exposing (Error, Response)
import Json.Decode as Dec exposing (int, bool, field, string)
import Json.Encode as Enc exposing (Value, object, string)
import Time exposing (millisecond)
import Result exposing (mapError)

-- Module needs refactoring

type alias Credentials = 
  { username: String
  , password: String
  }

type alias Registration = 
  { username: String
  , password: String
  , passwordRepeat: String
  }

type APIError = BadCredentials | ServerError | UsernameTaken | InvalidData | NotAuthenticated

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

authenticate : Credentials -> String -> (Result APIError (Bool, String) -> msg) -> Cmd msg
authenticate creds token msg =
  let
    encodedCreds = Http.jsonBody <| encodeCredentials creds
    mapLoginError = mapError getLoginError
  in
    Http.send (msg << mapLoginError) <| loginRequest token encodedCreds

register : Registration -> String -> (Result APIError (String) -> msg) -> Cmd msg
register reg token msg =
  let
    mapRegisterError = mapError getRegisterError
  in
    Http.send (msg << mapRegisterError) <|
      Http.request
        { method = "POST"
        , headers = [ Http.header "X-CSRFToken" token ]
        , url = "http://localhost:8000/register" 
        , body = Http.jsonBody <| encodeRegistration reg
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = True
        }


encodeCredentials : Credentials -> Value
encodeCredentials creds =
  object 
  [ ("username", Enc.string creds.username)
  , ("password", Enc.string creds.password)
  ]

encodeRegistration : Registration -> Value
encodeRegistration reg =
  object 
    [ ("username", Enc.string reg.username)
    , ("password", Enc.string reg.password)
    , ("passwordRepeat", Enc.string reg.passwordRepeat)
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

getStatusCode : Response a -> Int
getStatusCode res = res.status.code

getLoginError : Error -> APIError
getLoginError httpError =
  case httpError of
    Http.BadStatus r -> BadCredentials
    _ -> ServerError

getRegisterError : Error -> APIError
getRegisterError httpError =
  case httpError of
    Http.BadStatus res ->
      case getStatusCode res of
        400 -> InvalidData
        409 -> UsernameTaken
        _ -> ServerError
    _ -> ServerError

-- Get token from response?
storePhoto : String -> String -> (Result APIError String -> msg) -> Cmd msg
storePhoto token photoURL msg =
  let
    body = object [ ("url", Enc.string photoURL) ]
    mapStoreError = mapError getStorePhotoError
  in
    Http.send (msg << mapStoreError) <|
      Http.request
        { method = "POST"
          , headers = [ Http.header "X-CSRFToken" token ]
          , url = "http://localhost:8000/save_photo" 
          , body = Http.jsonBody body
          , expect = Http.expectString
          , timeout = Nothing
          , withCredentials = True
          }

getStorePhotoError : Error -> APIError
getStorePhotoError err =
  case err of
    Http.BadStatus res ->
      case getStatusCode res of
        401 -> NotAuthenticated
        400 -> InvalidData
        _ -> ServerError
    _ -> ServerError