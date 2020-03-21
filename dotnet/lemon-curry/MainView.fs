module Views

open System.Windows
open System.Windows.Controls
open System.Windows.Controls.Primitives
open PeopleView
open PlacesView
open Components

type MainView() as this =
    inherit Grid()

    let leftCol = ColumnDefinition( Width = GridLength(200.0) )
    let rightCol = ColumnDefinition( Width = GridLength.Auto )
    let upRow = RowDefinition()
    let buttonPanel = ButtonPanel()
    let people = peopleView
    let places = placesView
    let changeView message =
        let (current, next) = if message = "people" then (places, people) else (people, places)
        do
            this.Children.Remove(current)
            this.Children.Add(next)

    do 
        this.Log()
        this.ColumnDefinitions.Add(leftCol)
        this.ColumnDefinitions.Add(rightCol)
        Grid.SetColumn(buttonPanel, 0)
        Grid.SetColumn(people, 1)
        Grid.SetColumn(places, 1)
        this.Children.Add(buttonPanel) |> ignore
        buttonPanel.Clicks() |> Observable.subscribe changeView |> ignore


    member this.PeopleView = peopleView
    member this.Log() = printfn "main view"