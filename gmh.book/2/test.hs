{-

test.hs in chapter 2.

-}

-- Double and Quadruple
double x = x + x
quadruple x = double (double x)


-- Factorial of a positive integer
factorial n = product [1..n]

-- Average of a list of integers
average ns = sum ns `div` length ns
