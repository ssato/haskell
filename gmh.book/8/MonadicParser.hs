{-

Basic Monadic parsers.


TODO: quickcheck based tests
 -}

module MonadicParser where

import Data.Char
import Control.Monad

import Test.HUnit
import Test.QuickCheck (Property, quickCheck, (==>))
import Test.QuickCheck.Monadic (assert, monadicIO, run)


infixr 5 +++


-- The monad of parsers:
newtype Parser a =  P (String -> [(a, String)])

instance Monad Parser where
   return v = P $ \inp -> [(v, inp)]
   p >>= f = P $ \inp -> case parse p inp of
                           []        -> []
                           [(v, out)] -> parse (f v) out

{-
MonadPlus = Monad + Monoid
http://www.haskell.org/haskellwiki/Typeclassopedia#Other_monoidal_classes:_Alternative.2C_MonadPlus.2C_ArrowPlus

mzero ==> failure
mplus ==> choice
-}
instance MonadPlus Parser where
   mzero =  P $ \inp -> []
   p `mplus` q = P $ \inp -> case parse p inp of
                               []        -> parse q inp
                               [(v,out)] -> [(v,out)]

-- Basic parsers:
failure :: Parser a
failure =  mzero

item :: Parser Char
item = P $ \inp -> case inp of
                      []     -> []
                      (x:xs) -> [(x,xs)]

parse :: Parser a -> String -> [(a, String)]
parse (P p) inp = p inp


-- Choice
(+++) :: Parser a -> Parser a -> Parser a
p +++ q = p `mplus` q


-- Derived primitives
sat :: (Char -> Bool) -> Parser Char
sat p = do x <- item
           if p x then return x else failure

digit :: Parser Char
digit = sat isDigit

lower :: Parser Char
lower = sat isLower

upper :: Parser Char
upper = sat isUpper

letter :: Parser Char
letter = sat isAlpha

alphanum :: Parser Char
alphanum = sat isAlphaNum

char :: Char -> Parser Char
char x = sat (== x)

string :: String -> Parser String
string [] =  return []
string (x:xs) = char x >> string xs >> return (x:xs)


primitive_tests = do
    runTestTT $ Test.HUnit.test [
         "digit \"1\"" ~: (parse digit "1") ~?= [('1', "")]
        ,"digit \"123\"" ~: (parse digit "123") ~?= [('1', "23")]
        ,"digit \"c\"" ~: (parse digit "c") ~?= []
        ,"lower \"c\"" ~: (parse lower "c") ~?= [('c', "")]
        ,"lower \"abc\"" ~: (parse lower "abc") ~?= [('a', "bc")]
        ,"lower \"A\"" ~: (parse lower "A") ~?= []
        ,"upper \"C\"" ~: (parse upper "C") ~?= [('C', "")]
        ,"upper \"Abc\"" ~: (parse upper "ABC") ~?= [('A', "BC")]
        ,"upper \"a\"" ~: (parse upper "a") ~?= []
        ,"letter \"C\"" ~: (parse letter "C") ~?= [('C', "")]
        ,"letter \"1\"" ~: (parse letter "1") ~?= []
        ,"char 'a' \"abc\"" ~: (parse (char 'a') "abc") ~?= [('a', "bc")]
        ,"char 'a' \"xyz\"" ~: (parse (char 'a') "xyz") ~?= []
        ,"string []" ~: head (parse (string "") "") ~?= ("", "")
        ,"string s" ~: head (parse (string "hello") "hello, world") ~?= ("hello", ", world")
        ]


many :: Parser a -> Parser [a]
many p = many1 p +++ return []

many1 :: Parser a -> Parser [a]
many1 p = do v  <- p
             vs <- many p
             return (v:vs)

ident :: Parser String
ident = do x  <- lower
           xs <- many alphanum
           return (x:xs)

nat :: Parser Int
nat = do xs <- many1 digit
         return (read xs)

int :: Parser Int
int = do char '-'
         n <- nat
         return (- n)
        +++ nat

space :: Parser ()
space = many (sat isSpace) >> return ()


composites_tests = do
    runTestTT $ Test.HUnit.test [
         "ident" ~: (parse ident "abc123 -/$") ~?= [("abc123", " -/$")]
        ,"nat" ~: (parse nat "123abc") ~?= [(123, "abc")]
        ,"int" ~: (parse int "123abc") ~?= [(123, "abc")]
        ,"int -" ~: (parse int "-123abc") ~?= [(-123, "abc")]
        ,"space" ~: (parse space "   \t\nabc") ~?= [((), "abc")]
        ]


-- Ignoring spacing:
token :: Parser a -> Parser a
token p =  do space
              v <- p
              space
              return v

identifier :: Parser String
identifier = token ident

natural :: Parser Int
natural = token nat

integer :: Parser Int
integer = token int

symbol :: String -> Parser String
symbol xs = token (string xs)


others_tests = do
    runTestTT $ Test.HUnit.test [
         "identifier" ~: (parse identifier "  abc123 \tA-/$") ~?= [("abc123", "A-/$")]
        ,"natural" ~: (parse natural "  123 \tabc") ~?= [(123, "abc")]
        ,"integer" ~: (parse integer "  -123 \tabc") ~?= [(-123, "abc")]
        ,"symbol" ~: (parse (symbol "abc123_") "  \tabc123_\n  ") ~?= [("abc123_", "")]
        ]


runtests = primitive_tests >> composites_tests >> others_tests


-- vim:sw=4 ts=4 et:
