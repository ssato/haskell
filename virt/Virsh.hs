--
-- Libvirt's virsh wrapper in Haskell
--
-- Copyright (c) 2010 Satoru SATOH <ssato@redhat.com>
-- GPL version 3 or later.
--
module Main where

import Control.Monad
import System.Environment(getArgs)
import System.Process(readProcessWithExitCode)
import System.Exit(exitWith, ExitCode(ExitSuccess))
import Text.Regex.Posix
import Text.Printf


type VirshCmd = String  -- TODO: make it limited to valid commands only.


runVirsh :: VirshCmd -> [String] -> IO String
runVirsh c opts =
    do (rc,out,err) <- readProcessWithExitCode "sudo" ("virsh":c:opts) ""
       if rc == ExitSuccess
           then return out
           else fail $ "Failed: sudo virsh " ++ c ++ " " ++ unwords opts ++ ": " ++ err


matches :: String -> String -> [String]
matches s p = let r@((_,_,_,ss)) = s =~ p :: (String, String, String, [String]) in ss


list :: IO [[String]]
list = runVirsh "list" ["--all"] >>= return . vms
    where vms :: String -> [[String]] -- [[VmId, VmName, VmState]]
          vms c = [ms | l <- lines c, let ms = matches l " (-|[[:digit:]]+) ([^[:space:]]+) +(.+)", ms /= []]


vmNames :: IO [String]
vmNames = do { vs <- list; return [(\x@(a:b:c:_) -> b) v | v <- vs] }


findVm :: String -> IO Bool
findVm v = vmNames >>= return . elem v


listVms :: IO ()
listVms = list >>= mapM_ (\x@(a:b:c:_) -> printf "id=%s, name=%s, status=%s\n" a b c)



main :: IO ()
main = listVms

-- vim: set sw=4 ts=4 et:
