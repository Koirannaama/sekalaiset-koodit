module PlacesView

open System.Windows
open System.Windows.Controls

let placesView =
  let panel = StackPanel()
  let text = TextBlock( Text = "Places" )
  panel.Children.Add(text) |> ignore

  panel