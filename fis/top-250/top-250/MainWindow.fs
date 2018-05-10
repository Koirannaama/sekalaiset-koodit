module MainWindow

open FsXaml
open System.Windows
open Microsoft.FSharp.Control

type MainWindowBase = XAML<"MainWindow.xaml">

type MovieData = { movieName: string }
type MovieListing = { name: string; watched: bool; visible: bool }

let switchWatched movie =
    { movie with watched = not movie.watched }

let equals movie otherMovie =
    movie.name = otherMovie.name

// TODO: rename model, move to separate file
type Model = { movies: MovieListing List; selectedMovie: MovieListing Option }

let setVisibility (movie:MovieListing) isVisible =
    { movie with visible = isVisible }

let setSelectedMovie movie model = 
    { model with selectedMovie = movie }

let switchSelectedMovieWatched model =
    match model.selectedMovie with
    | Some selectedMovie ->
        let replaceUpdated listMovie = 
            if (equals listMovie selectedMovie) then switchWatched selectedMovie else listMovie
        let updatedMovies = List.map replaceUpdated model.movies
        { model with selectedMovie = Some <| switchWatched selectedMovie; movies = updatedMovies }
    | None -> model

// TODO: get actual data from somewhere
let getMovieData() = [
    { movieName = "Eternal Struggle" };
    { movieName = "A Star is Burns" }
]

let getMovieListings() =
    let movies = getMovieData()
    // TODO: get watched from file and compare
    List.map (fun movie -> { name = movie.movieName; watched = false; visible = true }) movies

let initialModel() =
    { movies = getMovieListings(); selectedMovie = None }

type MainWindow() as self = 
    inherit MainWindowBase()

    let switchVisibility model searchTerm =
        let updatedMovies = List.map (fun movie -> setVisibility movie (movie.name.ToLowerInvariant().Contains searchTerm)) model.movies
        { model with movies = updatedMovies }
    
    let m = initialModel()
    do self.DataContext <- m

    override self.checkBoxChange (_,_) = 
        self.DataContext <- switchSelectedMovieWatched (self.DataContext :?> Model)

    override self.selChange (s,e) = 
        let x = (s :?> Controls.ListBox).SelectedItem
        
        if x <> null then
            self.DataContext <- setSelectedMovie (Some (x :?> MovieListing)) (self.DataContext :?> Model)
        else
            self.DataContext <- setSelectedMovie None (self.DataContext :?> Model)

    override self.filterMovies (s,e) = self.DataContext <- (switchVisibility (self.DataContext :?> Model) (s :?> Controls.TextBox).Text)