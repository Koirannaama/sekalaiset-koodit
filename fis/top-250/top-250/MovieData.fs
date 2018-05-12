module MovieData

open FSharp.Data

type MovieDataSource = HtmlProvider<"https://www.imdb.com/chart/top">
type MovieRow = MovieDataSource.TopRatedMovies.Row
type MovieListing = { name: string; watched: bool; visible: bool }

let switchWatched movie =
    { movie with watched = not movie.watched }

let equals movie otherMovie =
    movie.name = otherMovie.name

let getMovieData() =
    let md = MovieDataSource()
    let rows = md.Tables.``Top Rated Movies``.Rows |> Array.toList
    List.map (fun (row: MovieRow) -> { name = row.``Rank & Title``; watched = false; visible = true }) rows

    