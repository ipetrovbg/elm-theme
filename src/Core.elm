module Core exposing (onEnterOrEsc, onEsc)

import Html exposing (Attribute)
import Html.Events exposing (keyCode, on)
import Json.Decode as Decode


onEnterOrEsc : msg -> msg -> Attribute msg
onEnterOrEsc enter esc =
    let
        isEnter code =
            if code == 13 then
                Decode.succeed enter

            else if code == 27 then
                Decode.succeed esc

            else
                Decode.fail "not ENTER"
    in
    on "keydown" (Decode.andThen isEnter keyCode)


onEsc : msg -> Attribute msg
onEsc esc =
    let
        isEnter code =
            if code == 27 then
                Decode.succeed esc

            else
                Decode.fail "not ENTER"
    in
    on "keydown" (Decode.andThen isEnter keyCode)
