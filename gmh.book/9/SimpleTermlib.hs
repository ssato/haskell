module SimpleTermlib where

import Data.Char
import Control.Monad


-- 9.4
echo :: IO ()
echo = do c <- getChar
          putChar '\n'
          putChar c
          putChar '\n'

echo' :: IO  ()
echo' = do c <- getChar
           putStr $ "\n" ++ [c] ++ "\n"


-- 9.5
getLine' :: IO String
getLine' = do c <- getChar
              if c == '\n' then
                  return []
                else
                  do { cs <- getLine'; return (c:cs); }

putStr' :: String -> IO ()
putStr' [] = return ()
putStr' (c:cs) = putChar c >> putStr cs

putStrLn' :: String -> IO ()
putStrLn' s = putStr' s >> putChar '\n'


beep :: IO ()
beep = putStr "\BEL"

cls :: IO ()
cls = putStr "\ESC[2J"


type Pos = (Int, Int)

goto :: Pos -> IO ()
goto (x, y) = putStr $ "\ESC[" ++ show y ++ ";" ++ show x ++ "H"

writeat :: Pos -> String -> IO ()
writeat p cs = goto p >> putStr cs

seqn :: [IO a] -> IO ()
seqn [] = return ()
seqn (a:as) = do { a; seqn as; }


-- putStr: another solution w/ seqn
putStr'' :: String -> IO ()
putStr'' cs = seqn [putChar c | c <- cs]


-- vim:sw=4 ts=4 et:
