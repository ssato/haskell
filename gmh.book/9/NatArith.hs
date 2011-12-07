{-
Parser for simple natural number arithmetic expressions
-}

module NatArith where

import MonadicParser


-- expr ::= term ('+' expr | empty)
expr :: Parser Int
expr =  do t <- term
           do symbol "+"               
              e <- expr
              return (t+e)
            +++ return t

-- term ::= factor ('*' term | empty)
term :: Parser Int
term =  do f <- factor
           do symbol "*"
              t <- term
              return (f * t)
            +++ return f

-- factor ::= '(' xpr ')' | natural
factor :: Parser Int
factor =  do symbol "("
             e <- expr
             symbol ")"
             return e
           +++ natural

eval :: String -> Int
eval cs =  case (parse expr cs) of
              [(n, [])]  -> n
              [(_, out)] -> error ("unused input: " ++ out)
              []         -> error ("invalid input: " ++ cs)


{-
session log:


ssato@localhost% ls
MonadicParser.hs  NatArith.hs  Parsing.lhs  parser.lhs  parsers.hs  session.log
ssato@localhost% ghci
GHCi, version 6.12.3: http://www.haskell.org/ghc/  :? for help
Loading package ghc-prim ... linking ... done.
Loading package integer-gmp ... linking ... done.
Loading package base ... linking ... done.
Loading package ffi-1.0 ... linking ... done.
ghci> :l NatArith.hs
[1 of 2] Compiling MonadicParser    ( MonadicParser.hs, interpreted )
[2 of 2] Compiling Main             ( NatArith.hs, interpreted )
Ok, modules loaded: MonadicParser, Main.
ghci> eval "2 * 3 + 4"
10
ghci> eval "2 * (3 + 4)"
14
ghci> eval "2 * (3 - 4)"
*** Exception: unused input: * (3 - 4)
ghci> eval "-1"
*** Exception: invalid input: -1
ghci>
Leaving GHCi.
ssato@localhost% 

-}
