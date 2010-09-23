--
-- Libvirt's virsh wrapper in Haskell
--
-- Copyright (c) 2010 Satoru SATOH <ssato@redhat.com>
-- GPL version 3 or later.
--
module Main where

import Control.Monad
import Data.List
import System.Environment(getArgs)
import System.Process(readProcessWithExitCode)
import System.Exit(exitWith, ExitCode(ExitSuccess))
import Text.Regex.Posix
import Text.Printf


type VirshCmd = String  -- TODO: make it limited to valid commands only.
type VmName = String


runVirsh :: VirshCmd -> [String] -> IO String
runVirsh c opts =
    --
    do (rc,out,err) <- readProcessWithExitCode "virsh" (c:opts) ""
       if rc == ExitSuccess
           then return out
           else fail $ "Failed: sudo virsh " ++ c ++ " " ++ unwords opts ++ ": " ++ err


matches :: String -> String -> [String]
matches s p = let r@((_,_,_,ss)) = s =~ p :: (String, String, String, [String]) in ss


parse :: String -> String -> [[String]]
parse p c = [ms | l <- lines c, let ms = matches l p, ms /= []]


list' :: VirshCmd -> String -> IO [[String]]
list' c p = runVirsh c ["--all"] >>= return . (parse p)


list :: VirshCmd -> IO [[String]]
list c = case c of
           "list" -> list' c " (-|[[:digit:]]+) ([^[:space:]]+) +(.+)"
           _      -> list' c "([^[:space:]]+) +([^[:space:]]+) +(.+)" >>= return . tail


vmExists :: VmName -> IO Bool
vmExists x = vms >>= return . elem x
    where vms = do { xs <- list "list"; return [(\y@(_:n:_) -> n) x | x <- xs] }


listVms :: IO ()
listVms = list "list" >>= mapM_ (\x@(a:b:c:_) -> printf "id=%s, name=%s, status=%s\n" a b c)


listXs :: VirshCmd -> IO ()
listXs c = list c >>= mapM_ (\x@(a:b:_) -> printf "name=%s, status=%s\n" a b)


main :: IO ()
main = do args <- getArgs
          case args of
            c:cs | c == "list" -> listVms
            c:cs | isInfixOf "list" c -> listXs c
            c:cs | otherwise -> runVirsh c cs >>= putStr
            _ -> error "Usage: Hvirsh VIRSH_COMMAND [OPTIONS...]"

-- vim: set sw=4 ts=4 et:
