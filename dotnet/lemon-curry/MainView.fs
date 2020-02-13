module Views

open System.Windows
open System.Windows.Controls
open System.Windows.Controls.Primitives

let buttonPanel =
    //let panel = DockPanel( LastChildFill = false )
    let placesButton = Button( Content = "Places" )
    let peopleButton = Button( Content = "People" )
    let uniformGrid = UniformGrid( Columns = 1)

    //uniformGrid.Columns <- 1

    //placesButton.Content <- "Places"
    //peopleButton.Content <- "People"

    //panel.LastChildFill <- false
    uniformGrid.Children.Add(placesButton) |> ignore
    uniformGrid.Children.Add(peopleButton) |> ignore
    uniformGrid

let MainView =
    let grid = Grid( ShowGridLines = true )
    let leftCol = ColumnDefinition( Width = GridLength(200.0) )
    let rightCol = ColumnDefinition( Width = GridLength.Auto )
    let upRow = RowDefinition()

    //grid.ShowGridLines <- true
    grid.ColumnDefinitions.Add(leftCol)
    grid.ColumnDefinitions.Add(rightCol)
    Grid.SetColumn(buttonPanel, 0)
    grid.Children.Add(buttonPanel) |> ignore

    //leftCol.Width <- GridLength(200.0)
    //rightCol.Width <- GridLength.Auto
    grid