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
import Data.List(filter, sort, group, length)
import System.Environment(getArgs, getProgName)


-- copied from http://nlpwp.org/book/chap-ngrams.xhtml:
ngrams :: Int64 -> T.Text -> [T.Text]
ngrams n = filter ((==) n . T.length) . map (T.take n) . T.tails

nngram :: Int64 -> T.Text -> [(T.Text, Int)]
nngram n = map (head &&& length) . group . sort . ngrams n

printNNgrams :: Int64 -> FilePath -> IO ()
printNNgrams n path = TI.readFile path >>= mapM_ pp . nngram n
    where 
          pp :: (T.Text, Int) -> IO ()
          pp (t, n) = TI.putStrLn $ T.append t $ T.pack $ " " ++ show n


main = do prog <- getProgName
          args <- getArgs
          case args of 
            ('-':cs):xs -> usage prog
            (n:fs) | length fs > 0 -> mapM_ (printNNgrams (read n)) fs
            _ -> usage prog
    where 
          usage :: String -> IO ()
          usage prog = putStrLn $ "Usage: " ++ prog ++ " INPUT_FILE_0 [INPUT_FILE_1 ...]"


-- vim:sw=4:ts=4:et:
