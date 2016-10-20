module GlobalTypes

type Coordinate = Coordinate of int * int
type MoveEvent = { fromCoord: Coordinate; toCoord: Coordinate }
type ShipModel = ShipModel of Coordinate

