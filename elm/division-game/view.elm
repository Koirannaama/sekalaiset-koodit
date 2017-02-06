module View exposing (view, Message(..), getMessageForResult)

import Html.Events exposing (onInput)
import Html.Attributes exposing (value, placeholder, class, classList)
import Html exposing (Html, div, input, text, p, table, tr, td)
import Global exposing (Msg)
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

highScoreDisplay : (List (String, Int)) -> Html a
highScoreDisplay scores =
  let
    row (name, score) = tr []
      [ td [] [ text name ], td [] [ text (toString score)] ]
    rows = List.map row scores
  in
    table [] rows

view model =
  div []
    [ div [ class "greeting" ] [ text "Guess a divisor of" ]
    , div [ class "greeting2"] [ text "(press Enter to submit)" ]
    , div [ class "number" ] [ text (toString model.randomNum) ]
    , input [ onInput Global.InputMsg, value model.input, placeholder "Enter 0 if it's a prime" ] []
    , messageDisplay model.message
    , scoreDisplay model.result model.highscore
    , highScoreDisplay model.highscores
    ]

getMessageForResult : GameLogic.GuessResult -> Message
getMessageForResult result =
  case result of
    GameLogic.Prime -> Congrats "Hooray!"
    GameLogic.Odd -> Congrats "Hooray!"
    GameLogic.Even -> Congrats "Hooray!"
    GameLogic.Trivial -> Congrats "Try again..."
    GameLogic.Wrong -> Wrong "Wrong."
