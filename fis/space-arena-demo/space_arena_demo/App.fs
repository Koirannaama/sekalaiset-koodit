module main

open System
open FsXaml
open View
open GlobalTypes
open Model

type App = XAML<"App.xaml">

[<STAThread>]
[<EntryPoint>]
let main argv =
    let initCoord = Coordinate (2, 3)
    let ship = ShipModel (initCoord, W)
    let (mv, gameBoardStream,  createMoveStream) = initMainView 50.0 (ship |> List.singleton)

    gameBoardStream
    |> Observable.scan updateModel ship
    |> Observable.map List.singleton
    |> createMoveStream
    |> ignore
    App().Run(mv)