module Test.FNV1a exposing (suite)

import Expect
import FNV1a
import Test exposing (..)


suite : Test
suite =
    describe "FNV1a"
        [ test "Simple test" <|
            \_ ->
                FNV1a.hash "Lorem ipsum"
                    |> Expect.equal 2898375356
        , test "Norwegian characters" <|
            \_ ->
                FNV1a.hash "Nå har jeg gått langt"
                    |> Expect.equal 84688665
        , test "Emoji" <|
            \_ ->
                FNV1a.hash "💩"
                    |> Expect.equal 949092445
        ]
