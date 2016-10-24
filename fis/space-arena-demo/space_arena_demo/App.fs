module main

open System
open FsXaml
open ViewModels
open GlobalTypes

type App = XAML<"App.xaml">

[<STAThread>]
[<EntryPoint>]
let main argv =
    let initCoord = Coordinate (2, 3)
    let ship = ShipModel initCoord
    let (mv, clickStream,  createMoveStream) = initMainView 50.0 ((ShipInMap initCoord) |> List.singleton)
    clickStream
    |> Observable.subscribe (fun (SquareClick(x, y)) -> mv.TestLabel.Content <- sprintf "%i, %i" x y)
    |> ignore

    clickStream
    |> Observable.scan (fun (ShipModel(c)) (SquareClick(x,y)) ->  Coordinate (x,y) |> ShipModel) ship
    |> Observable.map (fun (ShipModel(c)) -> ShipInMap c |> List.singleton)
    |> createMoveStream
    |> ignore
    App().Run(mv)