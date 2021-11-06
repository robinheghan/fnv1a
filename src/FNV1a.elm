module FNV1a exposing
    ( hash
    , hashWithSeed
    , initialSeed
    )

import Bitwise as Bit



{- Implementation has been ported from here: https://gist.github.com/vaiorabbit/5657561 -}


initialSeed : Int
initialSeed =
    0x811C9DC5


hash : String -> Int
hash str =
    hashWithSeed str initialSeed


hashWithSeed : String -> Int -> Int
hashWithSeed str seed =
    Bit.shiftRightZfBy 0 (String.foldl utf32ToUtf8 seed str)


utf32ToUtf8 : Char -> Int -> Int
utf32ToUtf8 char acc =
    let
        byte =
            Char.toCode char
    in
    if byte < 0x80 then
        hasher byte acc

    else if byte < 0x0800 then
        acc
            |> hasher (Bit.or 0xC0 <| Bit.shiftRightZfBy 6 byte)
            |> hasher (Bit.or 0x80 <| Bit.and 0x3F byte)

    else if byte < 0x00010000 then
        acc
            |> hasher (Bit.or 0xE0 <| Bit.shiftRightZfBy 12 byte)
            |> hasher (Bit.or 0x80 <| Bit.and 0x3F <| Bit.shiftRightZfBy 6 byte)
            |> hasher (Bit.or 0x80 <| Bit.and 0x3F byte)

    else
        acc
            |> hasher (Bit.or 0xF0 <| Bit.shiftRightZfBy 18 byte)
            |> hasher (Bit.or 0x80 <| Bit.and 0x3F <| Bit.shiftRightZfBy 12 byte)
            |> hasher (Bit.or 0x80 <| Bit.and 0x3F <| Bit.shiftRightZfBy 6 byte)
            |> hasher (Bit.or 0x80 <| Bit.and 0x3F byte)


hasher : Int -> Int -> Int
hasher byte hashValue =
    let
        mixed =
            Bit.xor byte hashValue
    in
    mixed
        + Bit.shiftLeftBy 1 mixed
        + Bit.shiftLeftBy 4 mixed
        + Bit.shiftLeftBy 7 mixed
        + Bit.shiftLeftBy 8 mixed
        + Bit.shiftLeftBy 24 mixed
