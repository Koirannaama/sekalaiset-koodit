namespace Components

open System.Windows
open System.Windows.Controls
open System.Windows.Controls.Primitives

type ButtonPanel() as this =
    inherit UniformGrid(Columns = 1)
    let placesButton = Button( Content = "Places" )
    let peopleButton = Button( Content = "People" )
    let peopleClicks = peopleButton.Click |> Observable.map ( fun _ -> "people" )
    let placesClicks = placesButton.Click |> Observable.map ( fun _ -> "places" )
    let clicks = Observable.merge peopleClicks placesClicks

    do
        this.Children.Add(placesButton) |> ignore
        this.Children.Add(peopleButton) |> ignore

    member this.Log() = printfn "button panel"
    member this.Clicks() = clicks