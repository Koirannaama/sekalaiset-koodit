module View exposing (view, Message(..), getMessageForResult)

import Html.Events exposing (onInput)
import Html.Attributes exposing (value, id, placeholder, class, classList)
import Html exposing (Html, div, input, text, p)
import Global exposing (Msg)
import GameLogic exposing (GuessResult)

type Message =
  Congrats String
  | Wrong String
  | Empty

scoreDisplay : Int -> Int -> Html a
scoreDisplay currentPoints highscore =
  div [ id "points" ] [ p [ id "cur-points"] [ text "Points: ", text (toString currentPoints) ]
                      , p [ id "highscore" ] [ text "Highscore: ", text (toString highscore) ] ]

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

view model =
  div []
    [ div [ id "greeting" ] [ text "Guess a divisor of" ]
    , div [ id "greeting2"] [ text "(press Enter to submit)" ]
    , div [ id "number" ] [ text (toString model.randomNum) ]
    , input [ onInput Global.InputMsg, value model.input, placeholder "Enter 0 if it's a prime" ] []
    , messageDisplay model.message
    , scoreDisplay model.result model.highscore
    ]

getMessageForResult : GameLogic.GuessResult -> Message
getMessageForResult result =
  case result of
    GameLogic.Prime -> Congrats "Hooray!"
    GameLogic.Odd -> Congrats "Hooray!"
    GameLogic.Even -> Congrats "Hooray!"
    GameLogic.Trivial -> Congrats "Try another..."
    GameLogic.Wrong -> Wrong "Wrong."
