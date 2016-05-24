module main

open System
open System.Windows
open System.Windows.Controls
open FsXaml
open ViewModels

type App = XAML<"App.xaml">

[<STAThread>]
[<EntryPoint>]
let main argv =
    let app = App()
    let mv = MainView()
    app.Root.Run(mv.Root)