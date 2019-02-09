port module Main exposing (..)

import Platform.Cmd exposing (Cmd, none, map)
import Platform.Sub exposing (Sub, none)
import Navigation exposing (Location)
import Keyboard exposing (KeyCode, presses)
import Model exposing (Model, isLoginVisible)
import Msg exposing (Msg(..))
import View exposing (getView)
import Routing exposing (parseLocation)
import Ports exposing (..)
import PhotoModel exposing (update, Msg(PhotoUrls, PlaceSuggestions, KeyPressed))
import GalleryModel exposing (update)
import LoginModel exposing (update)
import LoginMsg exposing (Msg(FormKeyPress, LoginResponse))
import API

init : Location -> (Model, Cmd Msg.Msg)
init loc = 
  let
    currentRoute = Routing.parseLocation loc
  in
    (Model.initModel currentRoute, (API.isAuthenticated Msg.IsAuthenticated))

main : Program Never Model Msg.Msg
main =
  Navigation.program ChangeView 
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = View.getView
    }

update : Msg.Msg -> Model -> (Model, Cmd Msg.Msg)
update msg model =
  case msg of
    PhotoMsg photoMsg ->
      let
        (newPhotoModel, cmd) = PhotoModel.update photoMsg model.photoModel
      in
        ({ model | photoModel = newPhotoModel }, (Cmd.map PhotoMsg cmd))
    GalleryMsg galleryMsg ->
      let
        (newGalleryModel, cmd) = GalleryModel.update galleryMsg model.galleryModel
      in
        ({ model | galleryModel = newGalleryModel}, (Cmd.map GalleryMsg cmd))
    LoginMsg loginMsg ->
      let
        (loggedIn, token) = case loginMsg of
            LoginResponse (Ok (_, token)) -> (True, token) -- Should a new CSRF token also be saved here?
            _ -> (model.isLoggedIn, model.csrfToken)
        (newLoginModel, cmd) = LoginModel.update loginMsg model.loginModel model.csrfToken
      in
        ({ model | loginModel = newLoginModel, isLoggedIn = loggedIn, csrfToken = token }, (Cmd.map LoginMsg cmd))
    ChangeView location ->
      let
        newRoute = parseLocation location
      in
        ({ model | route = newRoute }, Cmd.none)
    ToggleNavMenu ->
      ({ model | navMenuOpen = not model.navMenuOpen }, Cmd.none)
    Msg.KeyPressed keyCode ->
      let
        newMsg =
          if isLoginVisible model then
            FormKeyPress keyCode |> LoginMsg
          else
            PhotoModel.KeyPressed keyCode |> PhotoMsg
      in
        update newMsg model    
    IsAuthenticated (Ok (isAuth, token)) -> 
      ({ model | csrfToken = token, isLoggedIn = isAuth }, Cmd.none)
    IsAuthenticated (Err _) -> (model, Cmd.none)
    LoginSuccess -> ({ model | isLoggedIn = True }, Cmd.none)
    Logout ->
      let
        logoutCmd = API.logout model.csrfToken LogoutResult
      in
        (model, logoutCmd)
    LogoutResult (Ok (_)) -> ({ model | isLoggedIn = False }, Cmd.none) -- Holding on to the same CSRF token seems to work
    LogoutResult (Err _) -> (model, Cmd.none)

subscriptions : Model -> Sub Msg.Msg
subscriptions model =
  Sub.batch 
    [ photoUrls (PhotoUrls >> PhotoMsg)
    , placeSuggestions (PlaceSuggestions >> PhotoMsg)
    , Keyboard.presses (Msg.KeyPressed)
    ]
