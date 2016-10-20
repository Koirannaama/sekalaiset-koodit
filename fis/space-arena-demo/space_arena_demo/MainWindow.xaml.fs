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
type ShipInMap = Ship of Polygon * Coordinate

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

let private updateShips ships fromCoord toCoord sideLength =
    let checkShip (Ship(p, c) as s) = 
        if c = fromCoord then
            Ship (p, toCoord)
        else
            s
    ships
    |> List.map (fun s -> checkShip s) 
    
let private setPolygonCoords sideLength p x y =  
    let canvasX = (float x)*sideLength
    let canvasY = (float y)*sideLength
    Canvas.SetTop(p, canvasY)
    Canvas.SetLeft(p, canvasX)

let private createMoveStream sideLength initialState moveEvent =
    let movePolygonTo = setPolygonCoords sideLength
    let moveShipTo (Ship(p, (Coordinate(x,y)))) = movePolygonTo p x y

    moveEvent
    |> Observable.scan ( fun ships move -> updateShips ships move.fromCoord move.toCoord sideLength) initialState
    |> Observable.subscribe (fun ships -> List.iter moveShipTo ships)

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

let private setUpInitialState sideLength (ShipModel c) =
    let ship = ship()
    Ship (ship, c) |> List.singleton 

let private drawPolygon polygon (canvas:Canvas) x y =
    Canvas.SetTop(polygon, y)
    Canvas.SetLeft(polygon, x)
    canvas.Children.Add(polygon) |> ignore


let private squareClickStream (mv: MainView) sideLength =
  mv.BackgroundCanvas.MouseDown
  |> Observable.map (fun e -> let p = e.GetPosition(mv.BackgroundCanvas)
                              SquareClick(p.X / sideLength |> int, p.Y / sideLength |> int))

let initMainView (sideLength:float) (ship:ShipModel) =
    let mv = MainView()
    let initialState = setUpInitialState sideLength ship 
    List.iter (fun (Ship(p, (Coordinate(x,y)))) -> drawPolygon p mv.BackgroundCanvas ((float x)*sideLength) ((float y)*sideLength)) initialState
    
    let rec mouseMoveLoop prevSquare =
        async { 
            let! newSquare = Async.AwaitObservable(mouseMoveStream(mv))
            do setSquareColor prevSquare newSquare
            return! mouseMoveLoop(newSquare)
        }

    let squaresX = mv.BackgroundCanvas.Width / sideLength |> int
    let squaresY = mv.BackgroundCanvas.Height / sideLength |> int
    [for x in 0..squaresX-1 do for y in 0..squaresY-1 -> (x,y)]
    |> List.iter (fun (x, y) -> do 
                                let s = square(sideLength)
                                drawPolygon s mv.BackgroundCanvas (sideLength*float(x)) (sideLength*float(y))
                                )

    do Async.StartImmediate(mouseMoveLoop(Unknown))
        
    (mv, squareClickStream mv sideLength, createMoveStream sideLength initialState)

