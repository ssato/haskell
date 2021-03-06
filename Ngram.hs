{-# LANGUAGE OverloadedStrings, ViewPatterns #-}
-- Ngram sample
--
-- build: ghc --make -O2 <this_file>
--
-- Author: Satoru SATOH <ssato@redhat.com>
-- License: MIT

module Main (main) where

import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as TI

import Control.Arrow ((&&&))
import Control.Monad
import Data.Int(Int64)
import Data.List(filter, sort, group, length, tails)
import System.Environment(getArgs, getProgName)


-- copied from http://nlpwp.org/book/chap-ngrams.xhtml and modified to make it
-- work with Data.Text.Lazy:
ngrams :: Int64 -> T.Text -> [T.Text]
ngrams n = filter ((==) n . T.length) . map (T.take n) . T.tails

nngram :: Int64 -> T.Text -> [(T.Text, Int)]
nngram n = map (head &&& length) . group . sort . ngrams n

printNNgrams :: Int64 -> FilePath -> IO ()
printNNgrams n path = TI.readFile path >>= mapM_ pp . nngram n
    where 
          pp :: (T.Text, Int) -> IO ()
          pp (t, n) = TI.putStrLn $ T.append t $ T.pack $ " " ++ show n

-- for words:
wngrams :: Int -> [T.Text] -> [[T.Text]]
wngrams n = filter ((==) n . length) . map (take n) . tails

nwngram :: Int -> [T.Text] -> [([T.Text], Int)]
nwngram n = map (head &&& length) . group . sort . wngrams n

printNWNgrams :: Int -> FilePath -> IO ()
printNWNgrams n path = TI.readFile path >>= mapM_ pp . nwngram n . T.words
    where 
          pp :: ([T.Text], Int) -> IO ()
          pp (ts, n) = TI.putStrLn $ T.append (T.intercalate ", " ts) $ T.pack $ " " ++ show n


main = do prog <- getProgName
          args <- getArgs
          case args of 
            ("-w":n:fs) | length fs > 0 -> mapM_ (printNWNgrams (read n)) fs
            (n:fs) | length fs > 0 -> mapM_ (printNNgrams (read n)) fs
            _ -> usage prog
    where 
          usage :: String -> IO ()
          usage prog = putStrLn $ "Usage: " ++ prog ++ " [-w] N INPUT_FILE_0 [INPUT_FILE_1 ...]"


-- vim:sw=4:ts=4:et:
