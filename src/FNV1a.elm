module FNV1a exposing
    ( hash
    , hashWithSeed
    , initialSeed
    )

import Bitwise
import String.UTF8



{- Implementation has been ported from here: https://gist.github.com/vaiorabbit/5657561 -}


initialSeed : Int
initialSeed =
    0x811C9DC5


hash : String -> Int
hash str =
    hashWithSeed str initialSeed


hashWithSeed : String -> Int -> Int
hashWithSeed str seed =
    Bitwise.shiftRightZfBy 0 (String.UTF8.foldl hasher seed str)


hasher : Int -> Int -> Int
hasher byte hashValue =
    let
        mixed =
            Bitwise.xor byte hashValue
    in
    mixed
        + Bitwise.shiftLeftBy 1 mixed
        + Bitwise.shiftLeftBy 4 mixed
        + Bitwise.shiftLeftBy 7 mixed
        + Bitwise.shiftLeftBy 8 mixed
        + Bitwise.shiftLeftBy 24 mixed
