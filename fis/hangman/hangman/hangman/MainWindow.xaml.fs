namespace ViewModels

open System
open System.Windows
open FSharp.ViewModule
open FSharp.ViewModule.Validation
open FsXaml

type MainView = XAML<"MainWindow.xaml", true>

type HangmanModel = {
    MaxTries: int;
    Tries: int;
    SecretWord: string;
    Progress: string
} with
    member this.setSecretWord secretWord =
        { MaxTries = this.MaxTries; Tries = 0; SecretWord = secretWord; Progress = this.toDashes secretWord }

    member private this.toDashes word =
        String.map (fun c -> '-') word

    member this.checkGuess guess =
        let progress = this.updateProgress this.Progress <| this.checkHits guess this.SecretWord
        { MaxTries = this.MaxTries; Tries = this.Tries + 1; SecretWord = this.SecretWord; Progress = progress }

    member private this.checkHits guess word =
        String.map (fun c -> if c = guess then c else '-') word

    member private this.updateProgress progress hits =
        Seq.zip hits progress 
        |> Seq.map (fun t -> if (fst t) <> '-' then (fst t) else (snd t))
        |> String.Concat 

type MainViewModel() as self = 
    inherit ViewModelBase()

    let mutable hModel = { 
        MaxTries = 7; 
        Tries = 0; 
        SecretWord = "";
        Progress = ""
    }

    let winCondition progress =
        Seq.forall (fun c -> c <> '-') progress

    let checkWinCondition progress =
        winCondition progress
    
    let getGameStatus hModel = 
        if winCondition hModel.Progress 
        then "WIN"
        else if hModel.Tries = hModel.MaxTries
        then "LOSE"
        else ""
            
    let secretWordEntry = self.Factory.Backing(<@ self.SecretWordEntry @>, "")
    let progress = self.Factory.Backing(<@ self.Progress @>, "")
    let guess = self.Factory.Backing(<@ self.Guess @>, "")
    let resultText = self.Factory.Backing(<@ self.ResultText @>, "")

    let setSecret word = 
        hModel <- hModel.setSecretWord word
        progress.Value <- hModel.Progress
        secretWordEntry.Value <- ""
        resultText.Value <- ""

    let updateGame() =
        hModel <- hModel.checkGuess (guess.Value.Chars 0)
        progress.Value <- hModel.Progress
        resultText.Value <- getGameStatus hModel

    let doGuess() = 
        match resultText.Value with
        | "WIN" | "LOSE" -> ignore()
        | _ -> updateGame()

    member this.SecretWordEntry with get() = secretWordEntry.Value and set(value) = secretWordEntry.Value <- value
    member this.Progress with get() = progress.Value and set(value) = progress.Value <- value
    member this.Guess with get() = guess.Value and set(value) = guess.Value <- value
    member this.ResultText with get() = resultText.Value and set(value) = resultText.Value <- value

    member this.SetSecret = self.Factory.CommandSyncParam(setSecret)
    member this.DoGuess = self.Factory.CommandSync(doGuess)