module main

open System
open FsXaml
open ViewModels

type App = XAML<"App.xaml">

let isNotEmpty text =
    text <> ""

let init (mv: MainView) =
    mv.SubmitGuess.IsEnabled <- false
    mv.Guess.TextChanged
    |> Event.add (fun _ -> mv.SubmitGuess.IsEnabled <- isNotEmpty mv.Guess.Text)
    mv

[<STAThread>]
[<EntryPoint>]
let main argv =
    let mv = init(MainView())
    App().Root.Run(mv.Root)