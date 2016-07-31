// Learn more about F# at http://fsharp.org
// See the 'F# Tutorial' project for more help.

open System
open System.IO
open Microsoft.FSharp.Collections
open Word

module Words =

    let isEndChar char = 
        Seq.contains char Word.endChars

    let getFileName args =
        match args with
        | [|x; _|] -> Some x
        | [|x|] -> Some x
        | _ -> None
    
    let getFileContentToString filename =
        let lines = Option.map File.ReadLines filename
        let concatWithSpace = String.concat " "
        Option.map concatWithSpace lines

    let extractWordsFromText (text:String option) =
        match text with
        | Some s -> 
                s.Split([|' '|])
                |> Seq.map Word
        | _ -> Seq.empty
    
    let addPairToMap (map:Map<Word, Word list>) (word:Word, successor:Word) =
        match map.TryFind(word) with
        | Some l -> 
            let successors = successor::l
            Map.add word successors map
        | _ -> Map.add word [successor] map

    let mapWordsToSuccessors words =
        let successors = Seq.tail words
        let wordsWithSuccessors = Seq.zip words successors
        Seq.fold addPairToMap Map.empty wordsWithSuccessors

    let cleanResults (wordsAndSuccessors:Map<Word, Word list>) = 
        wordsAndSuccessors
        |> Map.filter (fun word succs -> notEmpty word && not <| List.isEmpty succs )
                            
    let getRandomIndex length = 
          let currentMillis = DateTime.Now.Millisecond
          currentMillis % length

//        let rnd = Random()
//        rnd.Next(0, lastIndex)

    let getRandomWordFrom words =
        let index =
            Seq.length words
            |> getRandomIndex
        Seq.item index words

    let charIsUpperCase char =
        Char.ToUpper char = char

    let getStartWord words =
        let startWords = 
            Seq.filter (fun w -> firstChar w |> charIsUpperCase) words
        getRandomWordFrom startWords

//    let getStartWords wordsAndSuccessors =
//        let getStartWordsFromSuccessors succs =
//            List.filter (fun w -> firstChar w |> charIsUpperCase) succs
//
//        let ifIsEndWordGetStartWords startWords word succs =
//            if containsEndChar word then
//                getStartWordsFromSuccessors succs
//                |> List.append startWords 
//            else
//                startWords
//
//        Map.fold ifIsEndWordGetStartWords [] wordsAndSuccessors
        
    let formSentence (wordsAndSuccessors:Map<Word, Word list>) =
        let rec pickNextWord word (wordsAndSuccs:Map<Word, Word list>) sentence =
            if containsEndChar word then
                Seq.append sentence [word]
            else
                let newWord = getRandomWordFrom <| Map.find word wordsAndSuccs
                let newSentence = Seq.append sentence [word]
                pickNextWord newWord wordsAndSuccs newSentence

//        let startWord = getStartWords wordsAndSuccessors
//                        |> getRandomWordFrom
        
        let startWord = Map.toSeq wordsAndSuccessors
                        |> Seq.map fst
                        |> getStartWord
        pickNextWord startWord wordsAndSuccessors []

    [<EntryPoint>]
    let main argv = 
        argv
        |> getFileName
        |> getFileContentToString
        |> extractWordsFromText
        |> mapWordsToSuccessors
        |> cleanResults
//        |> Map.iter (fun word succs -> printfn "--"
//                                       printWord word
//                                       Seq.iter printWord succs ) 
        |> formSentence
        |> Seq.iter printWord
        |> ignore
        0 // return an integer exit code
