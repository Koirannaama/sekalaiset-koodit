module Graph where

import qualified Data.Map as Map
import Prelude
import Data.List

data Kaari = Kaari { kohde :: String, pituus :: Int } deriving (Show)

data Solmu = Solmu  { nimi :: String, etaisyysAlusta :: Int } deriving (Show, Ord, Eq)

data Graafi = Graafi { solmut :: Map.Map Solmu [Kaari] } deriving (Show)

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
naapuriSolmut g s = filter (onkoSolmuaNimissa solmuNimet) (Map.keys (solmut g)) --map Solmu solmutNimet
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

haeSeuraava :: Graafi -> String -> [Solmu] -> String
haeSeuraava g s r = undefined

pituuteenEnsin :: Graafi -> Solmu -> [Solmu] -> Bool
pituuteenEnsin g m [] = False
pituuteenEnsin g m (x:xs)
  | onkoNaapurissa g x m = True
  | otherwise = pituuteenEnsin g m ((naapuriSolmut g x) ++ xs)


paaseekoSolmusta :: Graafi -> Solmu -> Solmu -> Bool
paaseekoSolmusta g l m = pituuteenEnsin g m [l]

haeReitti :: Graafi -> String -> String -> [Solmu]
haeReitti g l m = undefined
