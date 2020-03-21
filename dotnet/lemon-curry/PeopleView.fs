module PeopleView

open System.Windows
open System.Windows.Controls

let peopleView =
  let panel = StackPanel()
  let text = TextBlock( Text = "People" )
  panel.Children.Add(text) |> ignore

  panel