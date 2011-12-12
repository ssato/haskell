{-

Life Game in chapter 9.

 -}

module LifeGame where

import Data.Char
import Control.Monad
import SimpleTermlib


type Board = [Pos]

-- width and height of boards
width = 5 :: Int
height = 5 :: Int


-- board example:
glinder :: Board
glinder = [(4, 2), (2, 3), (4, 3), (3, 4), (4, 4)]


showcells :: Board -> IO ()
showcells b = seqn [writeat p "O" | p <- b]

isAlive :: Board -> Pos -> Bool
isAlive b p = p `elem` b

isEmpty :: Board -> Pos -> Bool
isEmpty b p = not $ isAlive b p


-- all cells [(x', y')] around Pos (x, y):
neighbs :: Pos -> [Pos]
neighbs (x, y) = map wrap [(x - 1, y - 1), (x, y - 1), (x - 1, y), (x + 1, y - 1),
                           (x - 1, y + 1), (x, y + 1), (x + 1, y), (x + 1, y + 1)]
    where wrap :: Pos -> Pos
          wrap (x, y) = ((x - 1) `mod` width + 1, (y - 1) `mod` height + 1)


-- live cells around Pos (x, y):
liveneighbs :: Board -> Pos -> [Pos]
liveneighbs b = filter (isAlive b) . neighbs

-- cound live cells around Pos (x, y):
nliveneighbs :: Board -> Pos -> Int
nliveneighbs b p = length $ liveneighbs b p


-- lived cells -> cells will live in next tern
survivors :: Board -> [Pos]
survivors b = [p | p <- b, f b p]
    where f b p = (nliveneighbs b p) `elem` [2, 3]


-- empty cells -> cells will live in next tern
-- naive implementation:
births0 :: Board -> [Pos]
births0 b = [(x, y) | x <- [1..width],
                      y <- [1..height],
                      isEmpty b (x, y),
                      nliveneighbs b (x, y) == 3]


-- this version is smarter than previous one: only search from empty cells of
-- which # of neighbors are 3:
births1 :: Board -> [Pos]
births1 b = [p | p <- f b,
                 isEmpty b p,
                 nliveneighbs b p == 3]
    where f = dedups . concat . map neighbs
          dedups = rmdups


rmdups :: Eq a => [a] -> [a]
rmdups [] = []
rmdups (x:xs) = x : rmdups (filter (/= x) xs)

births = births1


-- cells live in next turn (next generation):
nextgen :: Board -> Board
nextgen b = survivors b ++ births b


-- lifegame:
life :: Board -> IO ()
life b = cls >> (showcells b) >> wait t >> life (nextgen b)
    where t = 5000
          wait :: Int -> IO ()
          wait t = seqn [return () | _ <- [1..t]]


-- vim:sw=4 ts=4 et:
