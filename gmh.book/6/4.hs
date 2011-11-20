--
-- 6.4 Multiple recursions
--
module MultiRecursionExamples(fibonacci) where

import Test.QuickCheck
import Test.HUnit


-- fibonacci
fibonacci :: Int -> Int
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci 2 = 1
fibonacci n = fibonacci (n - 2) + fibonacci (n - 1)


unittests_fibonacci = Test.HUnit.test [
    "fibonacci 3" ~: fibonacci 3 ~?= 2
    ]

runtests = runTestTT unittests_fibonacci

-- vim:sw=4 ts=4 et:
