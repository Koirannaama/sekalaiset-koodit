module View exposing (view, Message(..), getMessageForResult)

import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (value, placeholder, class, classList)
import Html exposing (Html, div, input, text, p, table, tr, td, th, h2, button)
import Global exposing (Msg, Score, DataInputResult, comparePoints)
import GameLogic exposing (GuessResult)

type Message =
  Congrats String
  | Wrong String
  | Empty

scoreDisplay : Int -> Int -> Html a
scoreDisplay currentPoints highscore =
  div [ class "points" ]
    [ p [ class "cur-points"] [ text "Points: ", text (toString currentPoints) ]
    , p [ class "highscore" ] [ text "Highscore: ", text (toString highscore) ] ]

messageDisplay : Message -> Html a
messageDisplay msg =
  let
    getClassAndMessageText msg =
      case msg of
        Congrats msg ->
          ("congrats-message", msg)
        Wrong msg ->
          ("wrong-message", msg)
        Empty ->
          ("empty-message", "")
    (className, msgText) = getClassAndMessageText msg
    classes = [(className, True), ("msg-display", True)]
  in
    div [ classList classes ] [ text msgText ]

highScoreDisplay : (List Score) -> Html a
highScoreDisplay scores =
  let
    sortedScores = List.sortWith Global.comparePoints scores
    row (name, score) = tr [ class "score-row" ]
      [ td [ class "name-cell" ] [ text name ]
      , td [ class "points-cell" ] [ text (toString score)]
      ]
    rows = List.map row sortedScores
    header = th [ class "highscore-table-header" ] []
  in
    table [ class "highscore-table" ] (header :: header :: rows)

instructionText : String
instructionText = "(press Enter to submit, enter 0 if it's a prime)"

greetingDisplay : Html a
greetingDisplay =
  div [ class "greetings" ]
    [ div [ class "greeting" ] [ text "Guess a divisor of" ]
    , div [ class "greeting2"] [ text instructionText ]
    ]

nameInput : String -> Global.DataInputResult -> Html Msg
nameInput name inputResult =
  let
    mainClass = ("name-input", True)
    errorClass = ("input-error", True)
    classes =
      case inputResult of
        Global.OK -> [ mainClass ]
        Global.EmptyName -> [ mainClass, errorClass ]
        Global.ZeroScore -> [ mainClass, errorClass ]
  in
    input [ onInput Global.NameInput
          , value name
          , classList classes ] []

highscoreForm : String -> Global.DataInputResult -> Html Msg
highscoreForm name inputResult =
  div [ class "highscore-form" ]
  [ text "Name: "
  , nameInput name inputResult
  , button [ class "submit-score-button"
           , onClick Global.SendHighscore ] [ text "Submit score" ]
  ]

view model =
  div []
    [ div [ class "game-container"]
        [ greetingDisplay
        , div [ class "number" ] [ text (toString model.randomNum) ]
        , input [ onInput Global.InputMsg
                , value model.input
                , class "guess-input"
                ] []
        , messageDisplay model.message
        , scoreDisplay model.result model.highscore
        , highscoreForm model.name model.inputResult
        ]
    , div [ class "highscore-container"]
        [ h2 [ class "highscore-header" ] [ text "Highscores!" ]
        , highScoreDisplay model.highscores
        ]
    ]


getMessageForResult : GameLogic.GuessResult -> Message
getMessageForResult result =
  case result of
    GameLogic.Prime -> Congrats "Hooray!"
    GameLogic.Odd -> Congrats "Hooray!"
    GameLogic.Even -> Congrats "Hooray!"
    GameLogic.Trivial -> Congrats "Try again..."
    GameLogic.Wrong -> Wrong "Wrong."
