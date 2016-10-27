module Model

open System
open GlobalTypes

let private isMoveLegal deltaX deltaY orientation =
    match orientation with
    | N -> deltaX = 0 && deltaY = 1
    | W -> deltaX = -1 && deltaY = 0
    | S -> deltaX = 0 && deltaY = -1
    | E -> deltaX = 1 && deltaY = 0

let private updateShipPosition ((ShipModel(Coordinate(x1,y1), o)) as model) ((Coordinate(x2,y2)) as newCoord) =
    let deltaX = x2 - x1
    let deltaY = y2 - y1
    if isMoveLegal deltaX deltaY o then
        ShipModel (newCoord, o)
    else
        model

let updateModel (model:ShipModel) (event:GameBoardEvent) =
    match event with
    | SquareClick c -> updateShipPosition model c
    | RotateClick _ -> model