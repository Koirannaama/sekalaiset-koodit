module main

open System
open FsXaml
open ViewModels
open FSharp.Data

type App = XAML<"App.xaml">
type IlmatieteenLaitos = 
    XmlProvider<"http://data.fmi.fi/fmi-apikey/f07553d2-b501-486f-8acd-db58ca7d51eb/wfs?request=getFeature&storedquery_id=fmi::observations::weather::timevaluepair&parameters=temperature&place=Tampere&maxlocations=1">

[<STAThread>]
[<EntryPoint>]
let main argv =
   
    App().Root.Run()