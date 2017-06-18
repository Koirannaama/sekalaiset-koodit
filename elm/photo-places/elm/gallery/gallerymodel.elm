module GalleryModel exposing (..)

type Msg =
  SavePhoto String

type alias Model =
  { savedPhotos: List String }

initModel : Model
initModel = 
  { savedPhotos = [] }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SavePhoto photo ->
      ({ model | savedPhotos = photo :: model.savedPhotos }, Cmd.none)