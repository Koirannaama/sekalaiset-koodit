namespace ViewModels

open System
open System.Windows
open FSharp.ViewModule
open FSharp.ViewModule.Validation
open FsXaml

type MainView = XAML<"MainWindow.xaml", true>

type HangmanModel = {
    MaxTries:int;
    Tries:int;
    SecretWord:string
}

type MainViewModel() as self = 
    inherit ViewModelBase()

    let mutable hModel = {MaxTries = 7; Tries = 0; SecretWord = ""}

    let toDashes word =
        String.map (fun c -> '-') word

    let checkHits guess word =
        String.map (fun c -> if c = guess then c else '-') word

    let updateProgress progress hits =
        Seq.zip hits progress 
        |> Seq.map (fun t -> if (fst t) <> '-' then (fst t) else (snd t))
        |> String.Concat

    let winCondition progress =
        Seq.forall (fun c -> c <> '-') progress

    let checkWinCondition progress =
        winCondition progress
    
    let secretWordEntry = self.Factory.Backing(<@ self.SecretWordEntry @>, "")
    let progress = self.Factory.Backing(<@ self.Progress @>, "")
    let guess = self.Factory.Backing(<@ self.Guess @>, "")
    let winText = self.Factory.Backing(<@ self.WinText @>, "")

    let setSecret word = 
        hModel <- { hModel with SecretWord = word }
        progress.Value <- toDashes word
        winText.Value <- ""
        secretWordEntry.Value <- ""

    let doGuess() = 
        progress.Value <- updateProgress progress.Value <| checkHits (guess.Value.Chars 0) hModel.SecretWord
        winText.Value <- if checkWinCondition progress.Value then "WIN" else ""

    member this.SecretWordEntry with get() = secretWordEntry.Value and set(value) = secretWordEntry.Value <- value
    member this.Progress with get() = progress.Value and set(value) = progress.Value <- value
    member this.Guess with get() = guess.Value and set(value) = guess.Value <- value
    member this.WinText with get() = winText.Value and set(value) = winText.Value <- value

    member this.SetSecret = self.Factory.CommandSyncParam(setSecret)
    member this.DoGuess = self.Factory.CommandSync(doGuess)