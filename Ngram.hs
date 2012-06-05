-- rotate PDF with using pdftk
--
-- build: ghc --make -threaded -O2 pdfRotate.hs -o pdfRotate
--
-- Author: Satoru SATOH <ssato@redhat.com>
-- License: MIT

module Main (main) where

import qualified System.IO.UTF8 as U

import Data.List(tails, sort, group)
import Control.Arrow ((&&&))
import Control.Monad
import System.Environment(getArgs, getProgName)


-- tails in Data.List but easily defined as follows for example:
--
-- tails :: [a] -> [[a]]
-- tails [] = [[]]
-- tails x:xs = (x:xs) : tails xs

-- copied from http://nlpwp.org/book/chap-ngrams.xhtml:
ngrams :: Int -> [a] -> [[a]]
ngrams n = filter ((==) n . length) . map (take n) . tails

nngram :: Int -> String -> [(String, Int)]
nngram n = map (head &&& length) . group . sort . ngrams n

printNNgrams :: Int -> FilePath -> IO ()
printNNgrams n path = U.readFile path >>= mapM_ pp . nngram n
    where 
          pp :: (String, Int) -> IO ()
          pp (s, n) = U.putStrLn $ s ++ " " ++ show n


main = do prog <- getProgName
          args <- getArgs
          case args of 
            ('-':cs):xs -> usage prog
            fs | length fs > 0 -> mapM_ (printNNgrams n) fs
            _ -> usage prog
    where 
          n = 3
          usage :: String -> IO ()
          usage prog = putStrLn $ "Usage: " ++ prog ++ " INPUT_FILE_0 [INPUT_FILE_1 ...]"


-- vim:sw=4:ts=4:et:
