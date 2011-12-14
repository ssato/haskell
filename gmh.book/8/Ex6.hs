{-

NatArith + some extentions (operator '-' and '/')

 -}
module Ex6 where

import MonadicParser hiding (runtests)

import Test.HUnit
import Test.QuickCheck


-- expr ::= term ('+' expr | '-' expr | empty)
expr :: Parser Int
expr = do t <- term
          do symbol "+"
             e <- expr
             return (t + e)
            +++ do symbol "-"
                   e <- expr
                   return (t - e)
            +++ return t

-- term ::= factor ('*' term | '/' term | empty)
term :: Parser Int
term =  do f <- factor
           do symbol "*"
              t <- term
              return (f * t)
             +++ do symbol "/"
                    t <- term
                    return (f `div` t)  -- instead of '/'.
             +++ return f


factor :: Parser Int
factor = do symbol "("
            e <- expr
            symbol ")"
            return e
          +++ natural

eval :: String -> Int
eval cs =  case (parse expr cs) of
              [(n, [])]  -> n
              [(_, out)] -> error ("unused input: " ++ out)
              []         -> error ("invalid input: " ++ cs)


runtests = do
    runTestTT $ Test.HUnit.test [
         "eval \"2 + 3\"" ~: eval "2 + 3" ~?= 5
        ,"eval \"7 - 3\"" ~: eval "7 - 3" ~?= 4
        ,"eval \"2 - 3\"" ~: eval "2 - 3" ~?= -1
        ,"eval \"4 + 2 - 3\"" ~: eval "4 + 2 - 3" ~?= 3
        ,"eval \"3 * 4\"" ~: eval "3 * 4" ~?= 12
        ,"eval \"4 / 2\"" ~: eval "4 / 2" ~?= 2
        ,"eval \"3 / 2\"" ~: eval "3 / 2" ~?= 1
        ,"eval \"2 / 3\"" ~: eval "2 / 3" ~?= 0
        ,"eval \"1 + 2 * 7 / 3 - 2\"" ~: eval "1 + 2 * 7 / 3 - 2" ~?= 3
        ,"eval \"(1 + 2) * 3\"" ~: eval "(1 + 2) * 3" ~?= 9
        ]

{-
session log:

ghci> :l Ex6.hs
[1 of 2] Compiling MonadicParser    ( MonadicParser.hs, interpreted )
[2 of 2] Compiling Ex6              ( Ex6.hs, interpreted )
Ok, modules loaded: Ex6, MonadicParser.
ghci> eval "2 + 3 * 5 - 3"
14
ghci> eval "2 + 3 * 5 - 3 - 2"
16
ghci> eval "2 + 3 * 5 / 1"
17
ghci>

-}
