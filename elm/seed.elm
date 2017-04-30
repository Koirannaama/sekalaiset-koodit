import Html exposing (program)
import Platform.Cmd exposing (Cmd)

type alias Model = {}

init : (Model, Cmd Msg)
init =

main =
  Html.program { init = init,
                 update = update,
                 subscriptions = subscriptions,
                 view = view }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =

view : Model -> Html Msg
view model =

subscriptions : Model -> Sub Msg
subscriptions model =
