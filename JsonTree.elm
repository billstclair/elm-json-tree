----------------------------------------------------------------------
--
-- JsonTree.elm
-- Turn JSON into a tree.
-- Copyright (c) 2018 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE.txt
--
----------------------------------------------------------------------


module JsonTree exposing (JsonTree(..), decodeString, decodeValue, jsonTreeDecoder)

{-| A generalized JSON parser.


# Type

@docs JsonTree


# Functions

@docs decodeString, decodeValue


# Decoder

@docs jsonTreeDecoder

-}

import Json.Decode as JD exposing (Decoder, Value)


{-| Represent any valid JSON value.
-}
type JsonTree
    = JsonNull
    | JsonString String
    | JsonBool Bool
    | JsonInt Int
    | JsonFloat Float
    | JsonList (List JsonTree)
    | JsonObject (List ( String, JsonTree ))


{-| A `Decoder` for `JsonTree`
-}
jsonTreeDecoder : Decoder JsonTree
jsonTreeDecoder =
    JD.oneOf
        [ JD.null JsonNull
        , JD.map JsonString JD.string
        , JD.map JsonBool JD.bool
        , JD.map JsonInt JD.int
        , JD.map JsonFloat JD.float
        , JD.map JsonList <|
            JD.list (JD.lazy (\() -> jsonTreeDecoder))
        , JD.map JsonObject <|
            JD.keyValuePairs (JD.lazy (\() -> jsonTreeDecoder))
        ]


{-| Decode a string into a `JsonTree`.
-}
decodeString : String -> Result String JsonTree
decodeString json =
    JD.decodeString jsonTreeDecoder json


{-| Decode a value into a `JsonTree`.
-}
decodeValue : Value -> Result String JsonTree
decodeValue value =
    JD.decodeValue jsonTreeDecoder value
