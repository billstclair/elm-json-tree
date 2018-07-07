----------------------------------------------------------------------
--
-- Example.elm
-- Simple example of the JsonTree module.
-- Copyright (c) 2018 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE.txt
--
----------------------------------------------------------------------


module Exampl exposing (..)

import Html exposing (Attribute, Html, a, button, div, h2, input, p, span, text)
import Html.Attributes exposing (href, size, style, type_, value)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Json.Decode as JD
import JsonTree exposing (JsonTree)


main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }


type alias Model =
    { jsonString : String
    , result : Result String JsonTree
    }


initialModel : Model
initialModel =
    let
        string =
            "{\"null\": null, \"string\": \"Hello World\", \"List\": [1,2,3]}"
    in
    { jsonString = string
    , result = JsonTree.decodeString string
    }


type Msg
    = UpdateString String
    | KeyDown Int
    | Parse


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateString string ->
            { model | jsonString = string }

        KeyDown keycode ->
            if keycode == 13 then
                update Parse model
            else
                model

        Parse ->
            { model | result = JsonTree.decodeString model.jsonString }


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (JD.map tagger keyCode)


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "JsonTree Example" ]
        , p []
            [ input
                [ type_ "text"
                , value model.jsonString
                , onInput UpdateString
                , size 80
                , onKeyDown KeyDown
                ]
                []
            , text " "
            , button [ onClick Parse ]
                [ text "Parse" ]
            ]
        , p []
            [ case model.result of
                Ok tree ->
                    text <| toString tree

                Err err ->
                    span [ style [ ( "color", "red" ) ] ]
                        [ text err ]
            ]
        ]
