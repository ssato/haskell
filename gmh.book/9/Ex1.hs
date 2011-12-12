module SimpleTermlib2 where

import System.IO(getChar, putStr)
import Control.Monad
import SimpleTermlib


-- TBD: This is not correct.
readLine :: IO String
readLine = do c <- getChar
              if c == '\n' then
                  return []
                else
                  if c == '\DEL' then
                      do { putStr "\ESC[1D"; cs <- readLine; return cs; }
                    else
                      do { cs <- readLine; return (c:cs); }


-- vim:sw=4 ts=4 et:
