namespace ViewModels

open System
open System.Windows
open FSharp.ViewModule
open FSharp.ViewModule.Validation
open FsXaml

type MainView = XAML<"MainWindow.xaml", true>

type MainViewModel() as self = 
    inherit ViewModelBase()

    let toDashes word =
        String.map (fun c -> '-') word

    let checkHits guess word =
        String.map (fun c -> if c = guess then c else '-') word

    let updateProgress progress hits =
        Seq.zip hits progress 
        |> Seq.map (fun t -> if (fst t) <> '-' then (fst t) else (snd t))
        |> String.Concat

    let winCondition progress =
        Seq.exists (fun c -> c <> '-') progress

    let checkWinCondition progress winCond =
        winCond progress
    
    let secretWord = self.Factory.Backing(<@ self.SecretWord @>, "")
    let progress = self.Factory.Backing(<@ self.Progress @>, "")
    let guess = self.Factory.Backing(<@ self.Guess @>, "")
    let winText = self.Factory.Backing(<@ self.WinText @>, "")

    let setSecret() = 
        progress.Value <- toDashes secretWord.Value
        winText.Value <- ""

    let doGuess() = 
        progress.Value <- updateProgress progress.Value <| checkHits (guess.Value.Chars 0) secretWord.Value
        winText.Value <- if checkWinCondition progress.Value winCondition then "WIN" else ""

    member this.SecretWord with get() = secretWord.Value and set(value) = secretWord.Value <- value
    member this.Progress with get() = progress.Value and set(value) = progress.Value <- value
    member this.Guess with get() = guess.Value and set(value) = guess.Value <- value
    member this.WinText with get() = winText.Value and set(value) = winText.Value <- value

    member this.SetSecret = self.Factory.CommandSync(setSecret)
    member this.DoGuess = self.Factory.CommandSync(doGuess)