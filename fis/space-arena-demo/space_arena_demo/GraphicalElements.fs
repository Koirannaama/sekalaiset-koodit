module GraphicalElements

open System.Windows
open System.Windows.Media
open System.Windows.Controls
open System.Windows.Shapes


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

let ship(squareSideLength) =
    let top = 0.2 * squareSideLength
    let left = 0.2 * squareSideLength
    let bottom = 0.8 * squareSideLength
    let right = 0.8 * squareSideLength
    let mid = 0.5 * squareSideLength
//    new Polygon(Points=new PointCollection([new Point(0.0,0.0); 
//                                            new Point(15.0,0.0);
//                                            new Point(0.0,15.0)]),
    new Polygon(Points=new PointCollection([new Point(mid, top); 
                                            new Point(left, bottom);
                                            new Point(right, bottom)]),
                Stroke=Brushes.Aqua,
                Fill=Brushes.Beige)