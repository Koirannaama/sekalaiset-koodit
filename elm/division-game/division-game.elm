import Html exposing (Html, div, input, text, p)
import Html.App exposing (program)
import Html.Events exposing (onInput)
import Html.Attributes exposing (value, id, placeholder)
import Platform.Cmd exposing (Cmd, batch, none, map)
import String exposing (toInt)
import Arithmetic exposing (isPrime)
import Keyboard
import Random

type alias Model =
  { input : String,
    result: Int,
    randomNum: Int,
    highscore: Int
  }

enterKey : Keyboard.KeyCode
enterKey = 13

randomNumCmd : Cmd Msg
randomNumCmd = Random.generate RandomNum (Random.int 1 100)

checkAnswer : Int -> Int -> Model -> (Model, Cmd Msg)
checkAnswer answer num model =
  let remainder = num % answer
      modelAfterRightAnswer points =
        { model |
          input = "",
          result = model.result + points
        }
      modelAfterWrongAnswer = { model | input = "" }
  in
    if isPrime num && answer == 0 then
       (modelAfterRightAnswer 2, randomNumCmd)
    else if remainder == 0 then
      if answer == 1 || answer == num then
        (modelAfterWrongAnswer, randomNumCmd)
      else if answer == 2 then
        (modelAfterRightAnswer 1, randomNumCmd)
      else
        (modelAfterRightAnswer 2, randomNumCmd)
    else
      (modelAfterWrongAnswer, randomNumCmd)

init : (Model, Cmd Msg)
init = ({input = "", result = 0, randomNum = 0, highscore = 0}, randomNumCmd)

main =
  Html.App.program { init = init,
                     update = update,
                     subscriptions = subscriptions,
                     view = view }

scoreDisplay : Int -> Int -> Html a
scoreDisplay currentPoints highscore =
  div [ id "points" ] [ p [ id "cur-points"] [ text "Points: ", text (toString currentPoints) ]
                      , p [ id "highscore" ] [ text "Highscore: ", text (toString highscore) ] ]

view model =
  div []
    [ div [ id "greeting" ] [ text "Guess a divisor of" ]
    , div [ id "greeting2"] [ text "(press Enter to submit)" ]
    , div [ id "number" ] [ text (toString model.randomNum) ]
    , input [ onInput InputMsg, value model.input, placeholder "Enter 0 if it's a prime" ] []
    , div [ id "points" ] [ text (toString model.result) ]
    ]

type Msg =
  KeyMsg Keyboard.KeyCode
  | InputMsg String
  | RandomNum Int

update msg model =
  case msg of
    KeyMsg 13 ->
      case String.toInt model.input of
        Ok num ->
          checkAnswer num model.randomNum model
        Err _ ->
          (model, Cmd.none)
    KeyMsg _ ->
      (model, Cmd.none)
    InputMsg input ->
      ({ model | input = input }, Cmd.none)
    RandomNum num ->
      ({ model | randomNum = num}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Keyboard.downs KeyMsg ]
