module FNV1a exposing (hash, hashWithSeed)

import Bitwise



{- Implementation has been ported from here: https://gist.github.com/vaiorabbit/5657561 -}


initialSeed : Int
initialSeed =
    0x811C9DC5


hash : String -> Int
hash str =
    hashWithSeed initialSeed str


hashWithSeed : Int -> String -> Int
hashWithSeed seed str =
    Bitwise.shiftRightZfBy 0 (String.foldl hasher seed str)


hasher : Char -> Int -> Int
hasher char hashValue =
    let
        withCharCode =
            Bitwise.xor (Char.toCode char) hashValue
    in
    withCharCode
        + Bitwise.shiftLeftBy 1 withCharCode
        + Bitwise.shiftLeftBy 4 withCharCode
        + Bitwise.shiftLeftBy 7 withCharCode
        + Bitwise.shiftLeftBy 8 withCharCode
        + Bitwise.shiftLeftBy 24 withCharCode
