module Ex8 where

import MonadicParser hiding (runtests)
import Test.HUnit


-- expr ::= natural ('-' natural)*
expr :: Parser Int
expr = do n <- natural
          ns <- many (do { symbol "-"; natural; })
          return $ foldl (-) n ns


eval :: String -> Int
eval cs =  case (parse expr cs) of
              [(n, [])]  -> n
              [(_, out)] -> error ("unused input: " ++ out)
              []         -> error ("invalid input: " ++ cs)


runtests = do
    runTestTT $ Test.HUnit.test [
         "eval \"7 - 3\"" ~: eval "7 - 3" ~?= 4
        ,"eval \"2 - 3\"" ~: eval "2 - 3" ~?= -1
        ,"eval \"7 - 2 - 3\"" ~: eval "7 - 2 - 3" ~?= 2
        ]

{-
session log:

ghci> :l Ex8.hs
[1 of 2] Compiling MonadicParser    ( MonadicParser.hs, interpreted )
[2 of 2] Compiling Ex8              ( Ex8.hs, interpreted )
Ok, modules loaded: Ex8, MonadicParser.
ghci> eval "7 - 3"
4
ghci> eval "2 - 3"
-1
ghci> eval "7 - 2  -3"
2
ghci> runtests
Cases: 3  Tried: 3  Errors: 0  Failures: 0
Counts {cases = 3, tried = 3, errors = 0, failures = 0}
ghci>

-}

-- vim:sw=4 ts=4 et:
