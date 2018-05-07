module MainWindow

open FsXaml
open System.Windows

type MainWindow = XAML<"MainWindow.xaml">

type MovieData = { movieName: string }
type MovieListing = { name: string; watched: bool; visible: bool }

// TODO: get actual data from somewhere
let getMovieData() = [
    { movieName = "Eternal Struggle" };
    { movieName = "A Star is Burns" }
]

let getMovieListings() =
    let movies = getMovieData()
    List.map (fun movie -> { name = movie.movieName; watched = false; visible = true }) movies

let filterByTerm list term =
    List.filter (fun (item: MovieListing) -> item.name.ToLowerInvariant().Contains term) list

let setVisibility (movie:MovieListing) isVisible =
    { movie with visible = isVisible }

let switchVisibility movies searchTerm =
    List.map (fun movie -> setVisibility movie (movie.name.ToLowerInvariant().Contains searchTerm)) movies

let handleSearchTextChange movies (textBox: Controls.TextBox) (movieListElement: Controls.ListBox) =
    movieListElement.ItemsSource <- switchVisibility movies textBox.Text

let getMainWindow() =
    let w = MainWindow()
    let movieListings = getMovieListings()
    w.movieList.ItemsSource <- movieListings
    w.searchField.TextChanged.AddHandler (fun s e -> w.movieList.ItemsSource <- (switchVisibility movieListings (s :?> Controls.TextBox).Text))
    w