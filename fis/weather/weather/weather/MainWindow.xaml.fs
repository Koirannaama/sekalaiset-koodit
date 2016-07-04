namespace ViewModels

open System
open System.Windows
open FSharp.ViewModule
open FSharp.ViewModule.Validation
open FsXaml
open FSharp.Data
open Microsoft.FSharp.Control

type IlmatieteenLaitos = 
    XmlProvider<"http://data.fmi.fi/fmi-apikey/f07553d2-b501-486f-8acd-db58ca7d51eb/wfs?request=getFeature&storedquery_id=fmi::observations::weather::timevaluepair&parameters=temperature&place=Tampere&maxlocations=1">

type TemperatureAgent<'T> = MailboxProcessor<'T>
type TenperatureMessage = | TemperatureMessage of decimal

type MainView = XAML<"MainWindow.xaml", true>

type MainViewModel() as self = 
    inherit ViewModelBase()

    let loadIntervalMs = 1000.0
    let temp = self.Factory.Backing(<@ self.Temp @>, "")
    let setTemperature tempr = 
        temp.Value <- tempr.ToString()
    
    let getTemp() =
        let data = IlmatieteenLaitos.GetSample()
        let someData =
            query {
                for point in data.Member.PointTimeSeriesObservation.Result.MeasurementTimeseries.Points do
                select (point.MeasurementTvp.Time, point.MeasurementTvp.Value)
            }
        Seq.head someData |> snd

    let task = async { return getTemp() }
    let timer = new System.Timers.Timer(loadIntervalMs)

    let temprAgent = 
        TemperatureAgent<TenperatureMessage>.Start(
            fun inbox ->
                let rec loop () =
                    async {
                        let! (TemperatureMessage(content)) = inbox.Receive()
                        setTemperature content
                        return! loop()
                    }
                loop()    
        )

    let postTemperatureMessage() = 
        getTemp() |> TemperatureMessage |> temprAgent.Post

    do timer.Elapsed.Add (fun _ -> postTemperatureMessage())
       timer.Start()

    member this.LoadTemp = self.Factory.CommandSync(postTemperatureMessage)
    member this.Temp with get() = temp.Value and set(value) = temp.Value <- value