module Ex3 where 

import Control.Monad
import SimpleTermlib(Pos, seqn, writeat)
import LifeGame


-- cells: lived -> empty 
empties :: Board -> [Pos]
empties b = [p | p <- b, f b p]
    where f b p = not $ (nliveneighbs b p) `elem` [2, 3]

showlivecells = showcells


-- b: [empty cell]
showemptycells :: Board -> IO ()
showemptycells b = seqn [writeat p " " | p <- b]


life' :: Board -> IO ()
life' b = do showlivecells (births b)
             showemptycells (empties b)
             wait 5000
             life' $ nextgen b


-- vim:sw=4 ts=4 et:
