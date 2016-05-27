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
    
    let secretWord = self.Factory.Backing(<@ self.SecretWord @>, "")
    let progress = self.Factory.Backing(<@ self.Progress @>, "")
    let setSecret() = progress.Value <- toDashes secretWord.Value

    member this.SecretWord with get() = secretWord.Value and set(value) = secretWord.Value <- value
    member this.Progress with get() = progress.Value and set(value) = progress.Value <- value
    member this.SetSecret = self.Factory.CommandSync(setSecret)