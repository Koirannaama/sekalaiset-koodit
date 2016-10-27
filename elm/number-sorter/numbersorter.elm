import Html exposing (div, input, text)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (onInput)
import Result exposing (withDefault)
import String exposing (toInt, fromList, toList)
import Char exposing (isDigit)
import List exposing (isEmpty, sort)


main =
  beginnerProgram { model = "", view = view, update = update }


view model =
  div []
    [ input [ onInput Sort ] [] 
    , div [] [ text (toString (strToSortedNumList model)) ]
    ]


type Msg = Sort String

update msg model =
  case msg of
    Sort inputList ->
       inputList
       
charListToInt : List Char -> Int
charListToInt cs =
  let
    charsToResultInt = String.fromList >> String.toInt
  in
    Result.withDefault 0 (charsToResultInt cs)

numListHelper : List Char -> List Char -> List Int
numListHelper cs ds =
  case cs of
    [] -> 
      case ds of
        [] -> []
        ds -> charListToInt ds :: []
    c::cs ->
      if Char.isDigit c then
        numListHelper cs (ds ++ [c])
      else if (not << List.isEmpty) ds then
        charListToInt ds :: numListHelper cs []
      else
        numListHelper cs []
      
      

strToNumList : String -> List Int
strToNumList s = numListHelper (String.toList s) []

strToSortedNumList = sort << strToNumList