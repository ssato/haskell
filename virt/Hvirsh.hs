--
-- Libvirt's virsh (thin) wrapper in Haskell
--
-- Copyright (c) 2010 Satoru SATOH <ssato@redhat.com>
-- GPL version 3 or later.
--
module Main (main) where

import Control.Monad
import Data.List
import System.Environment(getArgs)
import System.Process(readProcessWithExitCode)
import System.Exit
import Text.Regex.Posix
import Text.Printf


type VirshCmd = String  -- TODO: make it limited to valid commands only.
type VmName = String


runVirsh :: VirshCmd -> [String] -> IO String
runVirsh c opts = do (rc,out,err) <- readProcessWithExitCode "virsh" (c:opts) ""
                     if rc == ExitSuccess then return out else error err


matches :: String -> String -> [String]
matches s p = let r@(_,_,_,ss) = s =~ p :: (String, String, String, [String]) in ss


parse :: String -> String -> [[String]]
parse p c = [ms | l <- lines c, let ms = matches l p, ms /= []]


list' :: VirshCmd -> String -> IO [[String]]
list' p c = runVirsh c ["--all"] >>= return . parse p
-- hlint suggests this:
-- list' p c = fmap (parse p) (runVirsh c ["--all"])


list :: VirshCmd -> IO [[String]]
list c | c == "list" = list' " (-|[[:digit:]]+) ([^[:space:]]+) +(.+)" c
       | otherwise   = fmap tail (list' "([^[:space:]]+) +([^[:space:]]+) +(.+)" c)


vmExists :: VmName -> IO Bool
vmExists x =  list "list" >>= elem x . map (\v@(_ : n : _) -> n)
-- hlint suggests this:
-- vmExists x = fmap (elem x . map (\v@(_ : n : _) -> n)) (list "list")


listVms :: IO ()
listVms = list "list" >>= mapM_ (\x@(a:b:c:_) -> printf "id=%s, name=%s, status=%s\n" a b c)


listXs :: VirshCmd -> IO ()
listXs c = list c >>= mapM_ (\x@(a:b:_) -> printf "name=%s, status=%s\n" a b)


main :: IO ()
main = do args <- getArgs
          case args of
            c:v:_ | c == "find" -> do { e <- vmExists v; if e then exitSuccess else exitFailure; }
            c:_   | c == "list" -> listVms
            c:_   | isInfixOf "list" c -> listXs c
            c:cs  | otherwise -> runVirsh c cs >>= putStr
            _ -> putStr "Usage: Hvirsh VIRSH_COMMAND [OPTIONS...]\n" >> exitFailure


-- vim: set sw=4 ts=4 et:
