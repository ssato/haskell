--
-- 8. Functional parsers
--
module Main where

import Monad
import Char
import Data.List
import Test.QuickCheck hiding (test)
import Test.HUnit


-- @see http://www.cs.nott.ac.uk/~gmh/Parsing.lhs
infixr 5 +++

newtype Parser a              =  P (String -> [(a,String)])

{-
-- 8.2 The parser type
type Parser a = String -> [(a, String)]
-- 8.3 Basic parsers
return' :: a -> Parser a
return' v = \x -> [(v, x)]  -- x: input

failure' :: Parser a
failure' = \x -> []
-}
instance Monad Parser where
   return' v          =  P (\inp -> [(v,inp)])
   p >>= f            =  P (\inp -> case parse' p inp of
                                         []        -> []
                                         [(v,out)] -> parse' (f v) out)

instance MonadPlus Parser where
   mzero              =  P (\inp -> [])
   p `mplus` q        =  P (\inp -> case parse' p inp of
                                         []        -> parse' q inp
                                         [(v,out)] -> [(v,out)])


parse' :: Parser a -> String -> [(a, String)]
parse' p x = p x


-- 8.4 Sequencing
(>>=) :: Parser a -> (a -> Parser b) -> Parser b
p >>= f = \x -> case parse' p x of
                     []        -> []
                     [(v,out)] -> parse' (f v) out

-- special syntax 'do':
--
-- ex.
-- p1 >>= \v1 ->
-- p2 >>= \v2 ->
-- ...
-- pn >>= \vn ->
-- return (f v1 v2 ... vn)
--
-- ====>
--
-- do v1 <- p1
--    v2 <- p2
--    ...
--    vn <- pn
--    return (f v1 v2 ... vn)
--
{-
p0 :: Parser (Char, Char)
p0 = do x <- item'
        item'
        y <- item'
        return' (x,y)
-}

-- 8.5 Choice
(+++) :: Parser a -> Parser a -> Parser a
p +++ q = \x -> case parse' p x of
                     []        -> parse' q x
                     [(v,out)] -> [(v,out)]



unittests = Test.HUnit.test [
        "return'" ~: parse' (return' 1) "hello" ~?= [(1,"hello")]
        -- FIXME: not works
        -- "failure'" ~: parse' failure' "hello" ~?= []
        ,"item' \"\"" ~: parse' item' "" ~?= []
        ,"item' \"...\"" ~: parse' item' "abc" ~?= [('a',"bc")]
        -- FIXME: not works
        -- ,"p0" ~: parse' p0 "abcdef" ~?= [(('a','c'),"def")]
        ,"+++" ~: parse' (item' +++ return' 'd') "abc" ~?= [('a',"bc")]
        ,"+++ failure or ..." ~: parse' (failure' +++ return' 'd') "abc" ~?= [('d',"abc")]
        -- FIXME: not works
        -- ,"+++ failure or failure" ~: parse' (failure' +++ failure') "abc" ~?= []
        ,"digit \"123\"" ~: parse' digit' "123" ~?= [('1',"23")]
        ,"digit \"abc\"" ~: parse' digit' "abc" ~?= []
        ,"char 'a' \"abc\"" ~: parse' (char' 'a') "abc" ~?= [('a', "abc")]
        ,"char 'a' \"123\"" ~: parse' (char' 'a') "123" ~?= []
        ,"string \"abc\"" ~: parse' (string' "abc") "abcdef" ~?= [("abc","def")]
        ,"string \"abc\"" ~: parse' (string' "abc") "ab1234" ~?= []
        ]


runtests = do runTestTT unittests


item' :: Parser Char
item' = \x -> case x of
                   []     -> []
                   (x:xs) -> [(x, xs)]

-- 8.6 Derived primitives
-- single chaacters that satisfy the predicate p
sat :: (Char -> Bool) -> Parser Char
sat p = do x <- item'
           if p x then return' x else failure'

-- 8/parsers.hs:94:16:
--   Couldn't match expected type `Char'
--   against inferred type `[(Char, String)]'
--   In the first argument of `p', namely `x'
--   In the expression: p x
--   In the expression: if p x then return' x else failure'

digit' :: Parser Char
digit' = sat Char.isDigit

lower' :: Parser Char
lower' = sat Char.isLower

upper' :: Parser Char
upper' = sat Char.isUpper

letter' :: Parser Char
letter' = sat Char.isAlpha

alphanum' :: Parser Char
alphanum' = sat Char.isAlphaNum

char' :: Char -> Parser Char
char' x = sat (== x)

-- string:
string' :: String -> Parser String
string' []     = return' []
string' (x:xs) = do char' x
                    string' xs
                    return' (x:xs)




