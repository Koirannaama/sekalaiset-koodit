module main

open System
open FsXaml
open ViewModels
open GlobalTypes
open Model

type App = XAML<"App.xaml">

[<STAThread>]
[<EntryPoint>]
let main argv =
    let initCoord = Coordinate (2, 3)
    let ship = ShipModel (initCoord, E)
    let (mv, clickStream,  createMoveStream) = initMainView 50.0 (ship |> List.singleton)
    clickStream
    |> Observable.subscribe (fun (SquareClick(Coordinate(x, y))) -> mv.TestLabel.Content <- sprintf "%i, %i" x y)
    |> ignore

    clickStream
    |> Observable.scan updateModel ship
    |> Observable.map List.singleton
    |> createMoveStream
    |> ignore
    App().Run(mv)