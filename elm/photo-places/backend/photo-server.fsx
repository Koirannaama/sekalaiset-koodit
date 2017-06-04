open System.IO
#r "./Suave.dll"
open Suave
open Suave.Filters
open Suave.Operators
open Suave.Successful

let app : WebPart =
  choose [
    GET >=> path "/" >=> Files.file "../main.html"
    GET >=> Files.browseHome
    //RequestErrors.NOT_FOUND "Page not found." 
  ]

let config =
  { defaultConfig with homeFolder = Some (Path.GetFullPath "../") }

startWebServer config app
    



