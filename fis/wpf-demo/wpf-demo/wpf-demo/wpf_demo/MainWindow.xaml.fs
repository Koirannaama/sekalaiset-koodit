namespace ViewModels

open System
open System.Windows
open System.Collections.ObjectModel
open FSharp.ViewModule
open FSharp.ViewModule.Validation
open FsXaml

type MainView = XAML<"MainWindow.xaml", true>

type MainViewModel() as self = 
    inherit ViewModelBase()

    let comments = ObservableCollection<String>()
    let newComment = self.Factory.Backing(<@ self.NewComment @>, "")
    let addComment() = comments.Add(newComment.Value)
        
    member this.NewComment with get() = newComment.Value and set(value) = newComment.Value <- value
    member this.Comments with get() = comments
    member this.AddCommentCommand = self.Factory.CommandSync(addComment)