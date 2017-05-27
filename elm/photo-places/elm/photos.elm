module Photos exposing (Photos, PhotoData, init, nextPhotoUrl, prevPhotoUrl, getPhotos, setPhotoUrls)

type Photos 
  = Photos { photoUrls: List String
           , currentPhotoNumber: Int
           }

type alias PhotoData 
  = { photoUrl: Maybe String 
    , currentPhotoNumber: Int
    , numberOfPhotos: Int}

init : Photos
init = Photos { photoUrls = [], currentPhotoNumber = 0 }

setPhotoUrls : List String -> Photos -> Photos
setPhotoUrls urls (Photos p) =
  Photos { p | photoUrls = urls }

firstToLast : List a -> List a
firstToLast list =
  case list of
    [] -> []
    [x] -> [x]
    x::xs -> List.append xs [x]

lastToFirst : List a -> List a
lastToFirst list =
  case List.reverse list of
    [] -> []
    [x] -> [x]
    x::xs -> x :: (List.reverse xs)

nextPhotoUrl : Photos -> Photos
nextPhotoUrl (Photos p) =
  let
    urls = firstToLast p.photoUrls
    newNumber = p.currentPhotoNumber + 1
  in
    Photos { p | photoUrls = urls, currentPhotoNumber = newNumber }

prevPhotoUrl : Photos -> Photos
prevPhotoUrl (Photos p) =
  let
    urls = lastToFirst p.photoUrls
    newNumber = p.currentPhotoNumber - 1
  in
    Photos { p | photoUrls = urls, currentPhotoNumber = newNumber }

getPhotos : Photos -> PhotoData
getPhotos (Photos p) = 
  let
    url = List.head p.photoUrls
    totalPhotos = List.length p.photoUrls
  in
   { photoUrl = url
   , currentPhotoNumber = p.currentPhotoNumber
   , numberOfPhotos = totalPhotos
   }

