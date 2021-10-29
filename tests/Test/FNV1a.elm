module Test.FNV1a exposing (suite)

import Expect
import FNV1a
import Test exposing (..)


suite : Test
suite =
    test "Expected return value" <|
        \_ ->
            Expect.equal
                1789342528
                (FNV1a.hash "Lorem")
