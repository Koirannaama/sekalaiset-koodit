module ViewModels

open System
open System.Windows
open System.Windows.Shapes
open System.Windows.Media
open System.Windows.Controls
open FSharp.ViewModule
open FSharp.ViewModule.Validation
open FSharpx.Control.Observable
open FsXaml
open GlobalTypes
open GraphicalElements

type MainView = XAML<"MainWindow.xaml">

// TODO: Liitä kiertonapit vuohon

type Square = KnownSquare of Polygon | Unknown

let private mouseMoveStream (squares: Polygon list) (canvas:Canvas) =
    let getEnterStreamFromPoly (poly:Polygon) = poly.MouseEnter |> Observable.map (fun _ -> KnownSquare poly)

    let exitStream = canvas.MouseLeave
                     |> Observable.map (fun e -> Unknown)
    List.fold (fun stream square -> getEnterStreamFromPoly square |> Observable.merge stream) exitStream squares
    
let private setPolygonCoords sideLength p x y =  
    let canvasX = (float x)*sideLength
    let canvasY = (float y)*sideLength
    Canvas.SetTop(p, canvasY)
    Canvas.SetLeft(p, canvasX)

let private drawPolygon x y (polygon:Polygon) =
    Canvas.SetTop(polygon, y)
    Canvas.SetLeft(polygon, x)
    polygon

let private addPolyToCanvas (canvas:Canvas) polygon =
    canvas.Children.Add(polygon) |> ignore

let private removeShips ships (canvas:Canvas) =
    ships
    |> List.iter (fun s -> canvas.Children.Remove(s))
    canvas

let private createShipPolygons sideLength ships (canvas:Canvas) =
    ships
    |> List.map (fun (ShipModel(Coordinate(x,y), _)) -> ship(sideLength) 
                                                        |> drawPolygon (float(x)*sideLength) (float(y)*sideLength))

let private createMoveStream sideLength (canvas:Canvas) initPolys moveEvent =
    let addShipToCanvas = addPolyToCanvas canvas

    moveEvent
    |> Observable.scan ( fun shipPolys shipData -> removeShips shipPolys canvas |> createShipPolygons sideLength shipData) initPolys
    |> Observable.subscribe (fun shipPolys -> List.iter addShipToCanvas shipPolys)

let private setSquareColor prevSquare newSquare =
    let setColor square color =
        match square with
        | KnownSquare s -> s.Stroke <- color
        | _ -> ignore()

    if prevSquare = newSquare then
        ignore()
    else
        do setColor prevSquare Brushes.Black
           setColor newSquare Brushes.Aqua

let private squareClickStream (mv: MainView) sideLength =
  mv.BackgroundCanvas.MouseDown
  |> Observable.map (fun e -> let p = e.GetPosition(mv.BackgroundCanvas)
                              SquareClick <| Coordinate(p.X / sideLength |> int, p.Y / sideLength |> int))

let initMainView (sideLength:float) initShips =
    let mv = MainView()
    let initShipPolys = createShipPolygons sideLength initShips mv.BackgroundCanvas

    let squaresX = mv.BackgroundCanvas.Width / sideLength |> int
    let squaresY = mv.BackgroundCanvas.Height / sideLength |> int
    let squares = [for x in 0..squaresX-1 do for y in 0..squaresY-1 -> (x,y)] 
                  |> List.map (fun (x, y) -> square sideLength |> drawPolygon (sideLength*float(x)) (sideLength*float(y)))

    let rec mouseMoveLoop prevSquare =
        async { 
            let! newSquare = Async.AwaitObservable(mouseMoveStream squares mv.BackgroundCanvas)
            do setSquareColor prevSquare newSquare
            return! mouseMoveLoop(newSquare)
        }

    do Async.StartImmediate(mouseMoveLoop(Unknown))
       List.iter (addPolyToCanvas mv.BackgroundCanvas) initShipPolys
       List.iter (addPolyToCanvas mv.BackgroundCanvas) squares
        
    (mv, squareClickStream mv sideLength, createMoveStream sideLength mv.BackgroundCanvas initShipPolys)

