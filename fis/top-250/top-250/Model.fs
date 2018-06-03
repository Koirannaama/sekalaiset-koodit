module Model

open MovieData

// TODO: sort movies based on rank after visibility changed
type Model = { movies: MovieListing list; selectedMovie: MovieListing Option }

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

// TODO: compare movie data to file
let initialModel() =
    { movies = getMovieData(); selectedMovie = None }

let private changeMovieVisibility model isMovieVisible =
    let ms = List.map (fun movie -> { movie with visible = (isMovieVisible movie) }) model.movies
    { model with movies = ms }

let switchWatchedVisible model =
    changeMovieVisibility model (fun movie -> movie.watched)

let switchNotWatchedVisible model =
    changeMovieVisibility model (fun movie -> not movie.watched)

let switchAllVisible model = 
    changeMovieVisibility model (fun _ -> true)