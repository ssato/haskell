module SimpleCalc where

import Data.Char
import System.IO
import SimpleTermlib

import MonadicParser(parse)
import NatArith(expr)


box :: [String]
box = ["+---------------+",
       "|               |",
       "+---+---+---+---+",
       "| q | c | d | = |",
       "+---+---+---+---+",
       "| 1 | 2 | 3 | + |",
       "+---+---+---+---+",
       "| 4 | 5 | 6 | - |",
       "+---+---+---+---+",
       "| 7 | 8 | 9 | * |",
       "+---+---+---+---+",
       "| 0 | ( | ) | / |",
       "+---+---+---+---+"]

buttons :: [Char]
buttons = quitButtons ++ delButtons ++ evalButtons ++ clsButtons ++ expButtons

quitButtons = "qQ\ESC"
delButtons = "dD\BS\DEL"
evalButtons = "=\n"
clsButtons = "cC"
expButtons = ns ++ ops
    where ns = concat [show n | n <- [0..9]]
          ops = "+-*/"

height = length box
width = length $ head box


showbox :: IO ()
showbox = seqn [writeat (1, y) cs | (y, cs) <- zip hs box]
    where hs = [1..height]


display :: String -> IO ()
display cs = do w [' ' | _ <- [1..width']]
                w $ reverse $ take width' $ reverse cs
    where w = writeat (3, 2)
          width' = length (head $ tail box) - 3 -- width of display area


-- from calculator.hs available from http://www.cs.nott.ac.uk/~gmh/book.html
getCh :: IO Char
getCh = do hSetEcho stdin False
           c <- getChar
           hSetEcho stdin True
           return c


calc :: String -> IO ()
calc cs = do display cs
             c <- getCh
             if c `elem` buttons then
                 process c cs
                else
                 do { beep; calc cs; }


process :: Char -> String -> IO ()
process c cs
    | c `elem` quitButtons = quit
    | c `elem` delButtons = delete cs
    | c `elem` evalButtons = eval cs
    | c `elem` clsButtons = clear
    | otherwise = press c cs

quit :: IO ()
quit = goto (1, height)

delete :: String -> IO ()
delete = calc . safeinit
    where safeinit :: [a] -> [a]
          safeinit [] = []
          safeinit cs = init cs

eval :: String -> IO ()
eval cs = case parse expr cs of 
            [(n, "")] -> calc (show n)
            _ -> do { beep; calc cs; }

clear  :: IO ()
clear = calc ""

press :: Char -> String -> IO ()
press c cs = calc $ cs ++ [c]


run :: IO ()
run = cls >> showbox >> clear

-- vim:sw=4 ts=4 et:
