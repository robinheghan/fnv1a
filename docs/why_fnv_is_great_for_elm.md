# Why FNV is a great hash function for Elm

Six years ago I released the `murmur3` package for Elm, which allows you to hash strings using the Murmur3 hash algorithm. I initially created the package for use in a hobby project I had going, where I implemented a hash array mapped trie (or HAMT) in pure Elm. Today, the package is being used in some wildly popular Elm packages like `elm-css` and `elm-graphql`.

This is a little unfortunate, as my `murmur3` implementation has a few weaknesses.

## A brief primer to hash functions

A hash function is a function that takes a string and returns an integer value that represents the value of that string. There are different types of hash functions, each with different trade offs.

Murmur3 is a non-cryptographic hash function. This means that it isn't concerned with how easy it is to build a table of all possible strings and their resulting hash, which can aid someone in finding a potential password if they know the hash.

Instead, a non-cryptographic hash function tends to favor two things:

* Speed. How quickly can you turn a string into its integer representation.
* Distribution. How low is the probability that two different strings has the same integer representation (also known as a collision).

Murmur3 is pretty good at both of these things. Unfortunetly, the way it works is hard to implement correctly in Elm.

## How Murmur3 achieves good performance

Hash functions tend to involve multiplying a combination of the previous hash value and the current character with, a prime number. This operation is, relatively speaking, expensive. Murmur3 works by first combining four 8-bit characters into a 32-bit integer, and then perform the remaining hash steps on that accumulated value. So, instead of performing multiplication every 8-bits, it does so every 32-bits instead.

Elm uses JavaScript strings, which are encoded using UTF-16. This means that every character is _at least_ 16-bits. All the characters in the world cannot fit within 16-bits, though (think Chinese, or emoji's), so certain characters are split in two 16-bit pairs.

The only way to iterate over the characters of a string in Elm, is by using `String.foldl` or `String.foldr`. These functions try hard to iterate over each individual character, regardless of its encoding, which means you have to manually check if the character is 16- or 32-bits in size.

Finally, even if something is 16-bits, most of those bits will be 0 if you're hashing over a latin-derived language.

Given these limitations, how are you supposed to implement a correct Murmur3 hash function?

## The weaknesses of Elm's murmur3 package

Six years ago, I was not aware of the inner workings of JavaScript strings. My murmur3 implementation works by combining the first 8-bits of every character into a 32-bit value. This means that if you're hashing something that contains non-english characters, you're more likely to get collisions, as all the bits in the string are not being used for calculating the hash. This can be fixed, but it would make the current implementation more complicated, and slower.

Another issue is that to be able to combine four characters at a time using `String.foldl`, I need to keep track of when I have accumulated enough characters to start hashing. This means that I have to allocate a data structure for every character in a string. It's not unlikely that this record-keeping defeats the performance advantage of Murmur3.

## FNV-1a

FNV is another non-cryptographic hash function with good performance and good disitribution. It hashes one byte at a time, instead of Murmur3's four bytes at a time, so its not as fast as Murmur3, but it seems to be close [when it comes to distribution](https://softwareengineering.stackexchange.com/questions/49550/which-hashing-algorithm-is-best-for-uniqueness-and-speed/145633#145633).

Since it hashes a byte at a time, it's simple to implement correctly in Elm without any overhead, even when decoding each character into a UTF-8 code point first to support any kind of language.

The benchmark in this repo shows that FNV is 60% faster than Murmur3 in Chrome, which is a noticable difference.

Because of this, I would recommend that people would switch from `robinheghan/murmur3` and use `robinheghan/fnv1a` instead. It's not only faster, but also more correct.
