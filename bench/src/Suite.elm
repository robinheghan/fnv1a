module Suite exposing (main)

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import FNV1a
import Murmur3


main : BenchmarkProgram
main =
    program suite


suite : Benchmark
suite =
    describe "FNV1a"
        [ Benchmark.compare "FNV vs Murmur3"
            "Murmur3"
            (\_ -> Murmur3.hashString 1024 testCase)
            "FNV1a"
            (\_ -> FNV1a.hash testCase)
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
