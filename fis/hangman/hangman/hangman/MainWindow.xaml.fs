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

    let checkGuess guess word =
        String.map (fun c -> if c = guess then c else '-') word

    let checkProgress progress hits =
        Seq.zip hits progress 
        |> Seq.map (fun t -> if (fst t) <> '-' then (fst t) else (snd t))
        |> String.Concat 
    
    let secretWord = self.Factory.Backing(<@ self.SecretWord @>, "")
    let progress = self.Factory.Backing(<@ self.Progress @>, "")
    let guess = self.Factory.Backing(<@ self.Guess @>, "")

    let setSecret() = progress.Value <- toDashes secretWord.Value
    let doGuess() = 
        progress.Value <- checkProgress progress.Value <| checkGuess (guess.Value.Chars 0) secretWord.Value

    member this.SecretWord with get() = secretWord.Value and set(value) = secretWord.Value <- value
    member this.Progress with get() = progress.Value and set(value) = progress.Value <- value
    member this.SetSecret = self.Factory.CommandSync(setSecret)
    member this.Guess with get() = guess.Value and set(value) = guess.Value <- value
    member this.DoGuess = self.Factory.CommandSync(doGuess)