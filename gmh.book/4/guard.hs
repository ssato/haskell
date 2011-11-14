{-
 - Guard examples
 -}

module GuardExamples where
import Test.QuickCheck
import Test.HUnit


abs' :: Int -> Int
abs' n | n >= 0    = n
       | otherwise = - n

signum' n | n < 0     = -1
          | n == 0    = 0
          | otherwise = 1


-- quickcheck test cases:
prop_positive_abs' n = n >= 0 ==> abs' n == n
        where types = n::Int

prop_negative_abs' n = n < 0 ==> abs' n == - n
        where types = n::Int

unittests = Test.HUnit.test [
         "signum': n < 0" ~: signum' (- 3) ~?= -1
        ,"signum': n == 0" ~: signum' 0 ~?= 0
        ,"signum': n >= 0" ~: signum' 4 ~?= 1
        ]

runtests = do quickCheck prop_positive_abs'
              quickCheck prop_negative_abs'
              runTestTT unittests


