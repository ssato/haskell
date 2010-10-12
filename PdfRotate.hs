-- rotate PDF with using pdftk
--
-- build: ghc --make -threaded -O2 pdfRotate.hs -o pdfRotate
--
-- Author: Satoru SATOH <ssato@redhat.com>
-- License: MIT

module Main (main) where

import Control.Concurrent
import Control.Monad
import System.Environment(getArgs)
import System.Process(runCommand, waitForProcess)
import System.Exit


type RotateOpt = String -- @see pdftk(1) for valid rotate options.

rotateCmd :: RotateOpt -> FilePath -> String
rotateCmd r x =
        let x'  = "\"" ++ x ++ "\""
            tmp = "\"" ++ x ++ ".tmp\""
        in "pdftk " ++ x' ++ " cat 1-end" ++ r ++ " output " ++ tmp ++ " && mv " ++ tmp ++ " " ++ x'

-- non-threaded version:
-- main = getArgs >>= mapM_ (\x -> waitForProcess =<< runCommand (rotateCmd "L" x))
-- threaded w/o no message version:
-- main = getArgs >>= mapM_ (\x -> forkIO (runCommand (rotateCmd "L" x) >>= waitForProcess >> return ()))
main = do args <- getArgs
          case args of 
            ('-':cs):xs -> usage
            xs | length xs > 0 -> mapM_ thread xs
            _ -> usage
    where 
          usage :: IO ()
          usage = putStrLn "Usage: PdfRotate INPUT_PDF_0 [INPUT_PDF_1 ...]"

          thread :: String -> IO ()
          thread x = do
              forkIO $ do
                         h <- runCommand $ rotateCmd "L" x
                         rc <- waitForProcess h
                         putStrLn $ x ++ " :" ++ (if rc == ExitSuccess then "OK" else "NG")
              return ()


{-
          thread :: String -> IO ()
          thread x = do
              m <- newEmptyMVar
              forkIO $ do
                         h <- runCommand $ rotateCmd "L" x
                         rc <- waitForProcess h
                         putMVar m (x ++ " :" ++ (if rc == ExitSuccess then "OK" else "NG"))
              s <- takeMVar m
              putStrLn s
-}
