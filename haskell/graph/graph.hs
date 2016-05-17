module Graph where

import qualified Data.Map as Map
import Prelude
import Data.List

data Kaari = Kaari { kohde :: String, pituus :: Int } deriving (Show)

data Solmu = Solmu  { nimi :: String, etaisyysAlusta :: Int } deriving (Ord)

data Graafi = Graafi { solmut :: Map.Map Solmu [Kaari] } deriving (Show)

instance Show Solmu where
  show s = nimi s

instance Eq Solmu where
  (==) s1 s2 = (nimi s1) == (nimi s2)



lisaaSolmu :: Graafi -> Solmu -> Graafi
lisaaSolmu g s = Graafi (Map.insert s [] (solmut g))

lisaaSolmut :: Graafi -> [Solmu] -> Graafi
lisaaSolmut g [] = g
lisaaSolmut g (x:xs) = lisaaSolmut (lisaaSolmu g x) xs

lisaaKaariSolmuun :: Graafi -> Solmu -> Kaari -> Graafi
lisaaKaariSolmuun g s k = Graafi (Map.insertWith (++) s [k] (solmut g))

onkoSolmuaNimissa :: [String] -> Solmu -> Bool
onkoSolmuaNimissa st s = elem (nimi s) st

naapuriSolmut :: Graafi -> Solmu -> [Solmu]
naapuriSolmut g s = filter (onkoSolmuaNimissa solmuNimet) (Map.keys (solmut g))
  where kaaret = (solmut g) Map.! s
        solmuNimet = map kohde kaaret

asetaSolmulleEtaisyys :: Solmu -> Int -> Solmu
asetaSolmulleEtaisyys s e = Solmu (nimi s) e

onkoSolmunNimi :: String -> Solmu -> Bool
onkoSolmunNimi n s = n == (nimi s)

-- head on vähän tyhmä ratkaisu
haeSolmuNimella :: Graafi -> String -> Solmu
haeSolmuNimella g n = head (filter (onkoSolmunNimi n) (Map.keys (solmut g)))

paivitaSolmuGraafiin :: Graafi -> Solmu -> Graafi
paivitaSolmuGraafiin g s = Graafi (Map.insert s kaaret solmuPoistettu )
  where poistettava = haeSolmuNimella g (nimi s)
        kaaret = (solmut g) Map.! poistettava
        solmuPoistettu = Map.delete poistettava (solmut g)

onkoNaapurissa :: Graafi -> Solmu -> Solmu -> Bool
onkoNaapurissa g l k = elem k (naapuriSolmut g l)

syvyyteenEnsin :: Graafi -> Solmu -> [Solmu] -> Bool
syvyyteenEnsin g m [] = False
syvyyteenEnsin g m (x:xs)
  | onkoNaapurissa g x m = True
  | otherwise = syvyyteenEnsin g m ((naapuriSolmut g x) ++ xs)

paaseekoSolmusta :: Graafi -> Solmu -> Solmu -> Bool
paaseekoSolmusta g l m = syvyyteenEnsin g m [l]

haeReitit :: Graafi -> Solmu -> [Solmu] -> [Solmu] -> [(Solmu, Solmu)]
haeReitit g m [] mt = []
haeReitit g m (x:xs) mt
  | m `elem` naapurit = [(m, x)]
  | otherwise = [(s2, s1) | s1 <- [x], s2 <- naapurit] ++ haeReitit g m naapurit mustat
    where mustat = x : mt
          naapurit = xs ++ ((naapuriSolmut g x) \\ mt)

haeReittiYhteyksista :: Map.Map Solmu Solmu -> Solmu -> Solmu -> [Solmu]
haeReittiYhteyksista yt l m
  | yt Map.! m == l = [m, l]
  | otherwise = m : haeReittiYhteyksista yt l (yt Map.! m)

haeReitti :: Graafi -> Solmu -> Solmu -> [Solmu]
haeReitti g l m
  | m `Map.member` yhteydet = haeReittiYhteyksista yhteydet l m
  | otherwise = []
    where yhteydet = Map.fromListWith (\s1 s2 -> s2) (haeReitit g m [l] [])
