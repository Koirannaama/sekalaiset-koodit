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

type MainView = XAML<"MainWindow.xaml">

type MainViewModel() as self = 
    inherit ViewModelBase()  

type SquareClick = SquareClick of int * int
type Square = KnownSquare of Polygon | Unknown
type ShipInMap = ShipInMap of Coordinate

let private squarePoints(sideLength) =
    new PointCollection([new Point(0.0, 0.0); 
                         new Point(sideLength, 0.0);
                         new Point(sideLength, sideLength);
                         new Point(0.0, sideLength)])

let private square(sideLength) = 
    new Polygon(Height=sideLength, 
                Width=sideLength,
                Points=squarePoints(sideLength),
                Stroke=Brushes.Black,
                StrokeThickness=2.0,
                Fill=Brushes.Transparent)

let private ship() =
    new Polygon(Points=new PointCollection([new Point(0.0,0.0); 
                                            new Point(15.0,0.0);
                                            new Point(0.0,15.0)]),
                Stroke=Brushes.Aqua,
                Fill=Brushes.Beige)
    

let private mouseMoveStream(mv: MainView) =
    let moveStream = mv.BackgroundCanvas.MouseMove
                     |> Observable.map (fun e -> match e.OriginalSource with 
                                                 | :? Polygon as p -> KnownSquare p
                                                 | _ -> Unknown )
    let exitStream = mv.BackgroundCanvas.MouseLeave
                     |> Observable.map (fun e -> Unknown)
    Observable.merge moveStream exitStream
    
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
    |> List.map (fun (ShipInMap(Coordinate(x,y))) -> ship() |> drawPolygon (float(x)*sideLength) (float(y)*sideLength))

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
                              SquareClick(p.X / sideLength |> int, p.Y / sideLength |> int))

let initMainView (sideLength:float) initShips =
    let mv = MainView()
    
    let rec mouseMoveLoop prevSquare =
        async { 
            let! newSquare = Async.AwaitObservable(mouseMoveStream(mv))
            do setSquareColor prevSquare newSquare
            return! mouseMoveLoop(newSquare)
        }

    let initPolys = createShipPolygons sideLength initShips mv.BackgroundCanvas

    let squaresX = mv.BackgroundCanvas.Width / sideLength |> int
    let squaresY = mv.BackgroundCanvas.Height / sideLength |> int
    [for x in 0..squaresX-1 do for y in 0..squaresY-1 -> (x,y)]
    |> List.iter (fun (x, y) -> do
                                let s = square(sideLength)
                                drawPolygon (sideLength*float(x)) (sideLength*float(y)) s |> ignore
                                addPolyToCanvas mv.BackgroundCanvas s)

    do Async.StartImmediate(mouseMoveLoop(Unknown))
       List.iter (addPolyToCanvas mv.BackgroundCanvas) initPolys
        
    (mv, squareClickStream mv sideLength, createMoveStream sideLength mv.BackgroundCanvas initPolys)

