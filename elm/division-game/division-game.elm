import Html exposing (program)
import Platform.Cmd exposing (Cmd, batch, none, map)
import String exposing (toInt)
import Keyboard
import Random
import View exposing (view, Message)
import Global exposing (Msg, Score, DataInputResult)
import GameLogic exposing (getResult, randomNumCmd)
import Scores exposing (getHighScores)

type alias Model =
  { input : String,
    result: Int,
    randomNum: Int,
    highscore: Int,
    message: View.Message,
    highscores: (List Score),
    name: String,
    inputResult: DataInputResult
  }


getHighscore : Int -> Int -> Int
getHighscore newScore oldHigh =
  if newScore >= oldHigh then
    newScore
  else
    oldHigh

checkAnswer : Int -> Int -> Model -> (Model, Cmd Msg)
checkAnswer answer num model =
  let modelAfterAnswer points message =
        { model |
          input = "",
          highscore = getHighscore points model.highscore,
          result = points,
          message = message
        }
      (result, points, cmd) = GameLogic.getResult answer num model.result
      message = View.getMessageForResult result
  in
    (modelAfterAnswer points message, cmd)

init : (Model, Cmd Msg)
init = ({ input = "",
          result = 0,
          randomNum = 0,
          highscore = 0,
          message = View.Empty,
          highscores = [],
          name = "",
          inputResult = Global.OK },
        Cmd.batch [ GameLogic.randomNumCmd, Scores.getHighScores ])

main =
  Html.program { init = init,
                 update = update,
                 subscriptions = subscriptions,
                 view = view }

update msg model =
  case msg of
    Global.KeyMsg 13 ->
      case String.toInt model.input of
        Ok num ->
          checkAnswer num model.randomNum model
        Err _ ->
          (model, GameLogic.randomNumCmd)
    Global.KeyMsg _ ->
      (model, Cmd.none)
    Global.InputMsg input ->
      ({ model | input = input }, Cmd.none)
    Global.RandomNum num ->
      ({ model | randomNum = num }, Cmd.none)
    Global.HighScores scores ->
      ({ model | highscores = scores }, Cmd.none)
    Global.NameInput name ->
      ({ model | name = name, inputResult = Global.OK }, Cmd.none)
    Global.SendHighscore ->
      if model.highscore == 0 || model.name == "" then --implement proper handling
        ({model | inputResult = Global.EmptyName }, Cmd.none)
      else
        ({model | inputResult = Global.OK },
        Scores.submitScore (model.name, model.highscore))

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Keyboard.downs Global.KeyMsg ]
