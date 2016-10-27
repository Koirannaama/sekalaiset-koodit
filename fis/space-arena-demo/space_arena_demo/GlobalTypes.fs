module GlobalTypes

type Coordinate = Coordinate of int * int
type Orientation = N | W | S | E
type ShipModel = ShipModel of Coordinate * Orientation
type Rotation = Clockwise | CounterClockwise
type GameBoardEvent = SquareClick of Coordinate | RotateClick of Rotation

let clockwise o =
    match o with
    | N -> E
    | E -> S
    | S -> W
    | W -> N

let counterClocwise o =
    match o with
    | N -> W
    | E -> N
    | S -> E
    | W -> S