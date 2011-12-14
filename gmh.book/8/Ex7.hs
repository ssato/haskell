module Ex7 where

import MonadicParser hiding (runtests)

import Test.HUnit


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

-- term ::= power ('*' term | '/' term | empty)
term :: Parser Int
term =  do p <- power
           do symbol "*"
              t <- term
              return (p * t)
             +++ do symbol "/"
                    t <- term
                    return (p `div` t)  -- instead of '/'.
             +++ return p

-- power ::= factor ('^' power | empty)
power :: Parser Int
power = do f <- factor
           do symbol "^"
              p <- power
              return (f ^ p)
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
        ,"eval \"2 ^ 3\"" ~: eval "2 ^ 3" ~?= 8
        ,"eval \"2 ^ 3 + 2\"" ~: eval "2 ^ 3 + 2" ~?= 10
        ,"eval \"2 ^ 3 - 2\"" ~: eval "2 ^ 3 - 2" ~?= 6
        ,"eval \"2 ^ 3 * 4\"" ~: eval "2 ^ 3 * 4" ~?= 32
        ,"eval \"2 ^ 3 / 4\"" ~: eval "2 ^ 3 / 4" ~?= 2
        ,"eval \"1 + 3 * 2 ^ 4 - 5\"" ~: eval "1 + 3 * 2 ^ 4 - 5" ~?= 44
        ]

{-
session log:

ghci> :l Ex7.hs
[1 of 2] Compiling MonadicParser    ( MonadicParser.hs, interpreted )
[2 of 2] Compiling Ex7              ( Ex7.hs, interpreted )
Ok, modules loaded: MonadicParser, Ex7.
ghci>
ghci> eval "2 + 3 ^ 2 * 5"
47
ghci> eval "2 + 3 ^ 2 * 5 / 5"
11
ghci>

-}

-- vim:sw=4 ts=4 et:
