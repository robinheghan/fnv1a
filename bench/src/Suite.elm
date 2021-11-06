module Suite exposing (main)

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import FNV1a
import Old.FNV1a


main : BenchmarkProgram
main =
    program suite


suite : Benchmark
suite =
    describe "FNV1a"
        [ Benchmark.compare "Old vs New"
            "Old"
            oldView
            "New"
            newView
        ]


testCase : String
testCase =
    """._33ecd3f8 {
    padding:16px;
    padding-left:24px;
    padding-right:24px;
    margin-left:50px;
    margin-right:auto;
    color:rgb(255, 255, 255);
    background-color:rgb(27, 217, 130);
    vertical-align:middle;
}"""


oldView : () -> Int
oldView _ =
    Old.FNV1a.hash testCase


newView : () -> Int
newView _ =
    FNV1a.hash testCase
