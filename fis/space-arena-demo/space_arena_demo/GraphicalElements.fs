module GraphicalElements

open System.Windows
open System.Windows.Media
open System.Windows.Controls
open System.Windows.Shapes
open GlobalTypes


let private squarePoints(sideLength) =
    new PointCollection([new Point(0.0, 0.0); 
                         new Point(sideLength, 0.0);
                         new Point(sideLength, sideLength);
                         new Point(0.0, sideLength)])

let square(sideLength) = 
    new Polygon(Height=sideLength, 
                Width=sideLength,
                Points=squarePoints(sideLength),
                Stroke=Brushes.Black,
                StrokeThickness=2.0,
                Fill=Brushes.Transparent)

let private orientationToAngle o =
    match o with
    | N -> 0.0
    | E -> 90.0
    | S -> 180.0
    | W -> 270.0

let private createRotation angle centerX centerY =
    new RotateTransform(angle, centerX, centerY)

let private orientationToRotation =
    orientationToAngle >> createRotation

let ship squareSideLength orientation =
    let top = 0.2 * squareSideLength
    let left = 0.2 * squareSideLength
    let bottom = 0.8 * squareSideLength
    let right = 0.8 * squareSideLength
    let mid = 0.5 * squareSideLength
    let rotate = orientationToRotation orientation mid mid
    new Polygon(Points=new PointCollection([new Point(mid, top); 
                                            new Point(left, bottom);
                                            new Point(right, bottom)]),
                Stroke=Brushes.Aqua,
                Fill=Brushes.Beige,
                RenderTransform=rotate)