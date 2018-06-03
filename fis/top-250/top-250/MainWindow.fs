module MainWindow

open FsXaml
open System.Windows
open Microsoft.FSharp.Control
open MovieData
open Model

type MainWindowBase = XAML<"MainWindow.xaml">

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
    override self.showOnlyWatched (_,_) = self.DataContext <- switchWatchedVisible (self.DataContext :?> Model)
    override self.showOnlyNotWatched (_,_) = self.DataContext <- switchNotWatchedVisible (self.DataContext :?> Model)
    override self.showAll (_,_) = self.DataContext <- switchAllVisible (self.DataContext :?> Model)