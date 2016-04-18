module GraphTests where

import Test.HUnit
import qualified Data.Map as Map
import Prelude
import Graph
import Graphhelp
import Data.List


tests = TestList
  [ TestLabel "simppeli testi syvyyteen ensin -haulle" test1,
    TestLabel "solmun lisays graafiin" test2
  ]

test1 = TestCase ( assertBool "syvyyteen ensin epaonnistui" (paaseekoSolmusta graph1 s1 s2) )
  where s1 = haeSolmuNimella graph1 "s1"
        s2 = haeSolmuNimella graph1 "s4"

test2 = TestCase ( assertBool "solmun lisays epaonnistui" (elem s (Map.keys (solmut g))))
  where s = Solmu "s" 1
        g = lisaaSolmu (Graafi Map.empty) s
