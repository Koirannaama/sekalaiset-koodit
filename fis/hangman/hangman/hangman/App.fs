module main

open System
open FsXaml
open ViewModels

type App = XAML<"App.xaml">

[<STAThread>]
[<EntryPoint>]
let main argv =
    let mv = MainView()
    App().Root.Run(mv.Root)