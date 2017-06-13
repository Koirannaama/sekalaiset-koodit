module Routing exposing (..)

import Navigation exposing (Location)
import Model exposing (Route(..))
import UrlParser exposing (..)

matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map PhotoRoute top
        , map GalleryRoute (s "gallery")
        ]

parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route
        Nothing ->
            NotFoundRoute

photoPath : String
photoPath = ""

galleryPath : String
galleryPath = "#gallery"