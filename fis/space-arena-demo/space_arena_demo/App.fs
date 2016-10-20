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
    let (mv, clickStream,  createMoveStream) = initMainView 50.0 ship
//    mv.BackgroundCanvas.MouseDown.Add (fun _ -> mv.TestLabel.Content <- "asd")
    clickStream
    |> Observable.subscribe (fun (SquareClick(x, y)) -> mv.TestLabel.Content <- sprintf "%i, %i" x y)
    |> ignore

    clickStream
    |> Observable.scan (fun (_, (ShipModel(c))) (SquareClick(x,y)) -> (c, Coordinate (x,y) |> ShipModel)) (initCoord,ship)
    |> Observable.map (fun (fromCoord, ShipModel(toCoord)) -> {fromCoord = fromCoord; toCoord = toCoord})
    |> createMoveStream
    |> ignore
//    clickStream
//    |> Observable.map (fun (SquareClick (x, y)) ->
    App().Run(mv)