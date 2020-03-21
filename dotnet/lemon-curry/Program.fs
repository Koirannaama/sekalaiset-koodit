// Learn more about F# at http://fsharp.org

open System
open System.Windows
open Views

[<EntryPoint>]
[<STAThread>]
let main argv =
    printfn "Hello World from F#!"
    let win = Window()
    let app = Application()
    let mainView = MainView()
    
    win.Content <- mainView
    win.Height <- 500.0
    win.Width <- 750.0
    win.Title <- "Lemon curry?"
    win.Show()
    
    app.MainWindow <- win
    app.Run()
