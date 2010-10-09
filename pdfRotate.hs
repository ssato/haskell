-- rotate PDF with using pdftk
--
-- build: ghc --make -threaded -O2 pdfRotate.hs -o pdfRotate
--
-- Author: Satoru SATOH <ssato@redhat.com>
-- License: MIT

module Main (main) where

import Control.Concurrent(forkIO)
import Control.Monad
import System.Environment(getArgs)
import System.Process(runCommand, waitForProcess)


type RotateOpt = String -- @see pdftk(1) for valid rotate options.

rotateCmd :: RotateOpt -> FilePath -> String
rotateCmd r x =
        let x'  = "\"" ++ x ++ "\""
            tmp = "\"" ++ x ++ ".tmp\""
        in "pdftk " ++ x' ++ " cat 1-end" ++ r ++ " output " ++ tmp ++ " && mv " ++ tmp ++ " " ++ x'

-- non-threaded version:
-- main = getArgs >>= mapM_ (\x -> waitForProcess =<< runCommand (rotateCmd "L" x))
main = getArgs >>= mapM_ (\x -> forkIO (runCommand (rotateCmd "L" x) >>= waitForProcess >> return ()))

