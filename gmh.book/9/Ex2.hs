module Ex2 where

import MonadicParser(parse)
import NatArith(expr)
import Control.Monad
import SimpleTermlib(beep, cls)
import SimpleCalc


eval' :: String -> IO ()
eval' cs = case parse expr cs of
            [(n, "")] -> calc (show n)
            [(_, rs)] -> display cs >> calc cs


calc' :: String -> IO ()
calc' cs = do display cs
              c <- getCh
              if c `elem` buttons then
                  process' c cs
                else
                  do { beep; calc' cs; }


process' :: Char -> String -> IO ()
process' c cs
    | c `elem` quitButtons = quit
    | c `elem` delButtons = delete cs
    | c `elem` evalButtons = eval' cs
    | c `elem` clsButtons = clear'
    | otherwise = press' c cs


clear'  :: IO ()
clear' = calc' ""

press' :: Char -> String -> IO ()
press' c cs = calc' $ cs ++ [c]

run' :: IO ()
run' = cls >> showbox >> clear'


-- vim:sw=4 ts=4 et:
