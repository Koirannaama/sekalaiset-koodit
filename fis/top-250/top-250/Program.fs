// Learn more about F# at http://fsharp.org
// See the 'F# Tutorial' project for more help.
module Main

open System
open System.Windows
open FsXaml

open MainWindow

type App = XAML<"App.xaml">

[<STAThread>]
[<EntryPoint>]
let main argv = 
    let app = App()
    let w = getMainWindow()
    app.Run(w)
