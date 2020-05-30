module Dropdown exposing (..)

import Html exposing (Attribute, Html, button, div, input, label, li, span, text, ul)
import Html.Attributes as Attributes exposing (checked, class, classList, for, name, type_)
import Html.Events exposing (keyCode, on, onClick)
import Json.Decode as Decode
import Types exposing (DropdownAttributes, Model, Msg(..), ToggledDropdown(..))


dropdownEnterDecoder : Decode.Decoder Bool
dropdownEnterDecoder =
    Decode.map toEnter (Decode.field "keyCode" Decode.int)


toEnter : Int -> Bool
toEnter wich =
    case wich of
        13 ->
            True

        _ ->
            False


isOutsideDropdown : String -> Decode.Decoder Bool
isOutsideDropdown dropdownId =
    Decode.oneOf
        [ Decode.field "id" Decode.string
            |> Decode.andThen
                (\id ->
                    if dropdownId == id then
                        Decode.succeed False

                    else
                        Decode.fail "check parent node"
                )
        , Decode.lazy (\_ -> isOutsideDropdown dropdownId |> Decode.field "parentNode")

        -- fallback if all previous decoders failed
        , Decode.succeed True
        ]


outsideTarget : String -> Decode.Decoder Msg
outsideTarget dropdownId =
    Decode.field "target" (isOutsideDropdown dropdownId)
        |> Decode.andThen
            (\isOutside ->
                if isOutside then
                    Decode.succeed
                        (ToggleDropdown Closed)

                else
                    Decode.fail "inside dropdown"
            )


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


isOpenDropdown : ToggledDropdown -> Bool
isOpenDropdown dropdownState =
    case dropdownState of
        Opened ->
            True

        Closed ->
            False


simpleDropdownData : List String
simpleDropdownData =
    [ "Plutonium"
    , "Americium"
    , "Curium"
    , "Berkelium"
    , "Californium"
    , "Fermium"
    , "Mendelevium"
    , "Nobelium"
    , "Lawrencium"
    , "Rutherfordium Rutherfordium"
    , "Dubnium"
    , "Seaborgium"
    , "Bohrium"
    , "Hassium"
    , "Neptunium"
    ]


dropdownConfig : Model -> DropdownAttributes
dropdownConfig model =
    Types.DropdownAttributes
        { title = Maybe.withDefault "Select an Element" (Tuple.second model.selectedDropdown)
        , open = model.dropdownState
        , id = "dropdown"
        , value = Maybe.withDefault "" (Tuple.second model.selectedDropdown)
        , toElement = \( index, element ) -> element
        }


dropdown :
    DropdownAttributes
    -> List String
    -> (( Int, String ) -> msg)
    -> (ToggledDropdown -> msg)
    -> Html msg
dropdown (Types.DropdownAttributes { title, open, id, value, toElement }) data select onOpen =
    --onOpen
    div [ class "dropdown", Attributes.id id ]
        [ div []
            [ button
                [ onClick (onOpen open)
                , Attributes.alt title
                , Attributes.title title
                , Attributes.id (id ++ "_wrapper")
                , class "dropdown-button-title"
                , classList [ ( "open", isOpenDropdown open ) ]
                ]
                [ span [ class "title" ] [ text title ]
                , span [ class "arrow" ] []
                ]
            , div [ class "relative dropdown-container", classList [ ( "open", isOpenDropdown open ) ] ]
                [ span [ class "arrow" ] []
                , ul
                    [ Attributes.id (id ++ "_wrapper")
                    , class "dropdown-items-container"
                    , classList [ ( "open", isOpenDropdown open ), ( "close", not (isOpenDropdown open) ) ]
                    ]
                    (List.indexedMap
                        (\index item ->
                            li [ class "dropdown-item" ]
                                [ input
                                    [ type_ "radio"
                                    , name "dropdown-name"
                                    , class "item"
                                    , checked
                                        (if value == item then
                                            True

                                         else
                                            False
                                        )
                                    , Attributes.id (String.fromInt index ++ "_" ++ id)
                                    , onEnterOrEsc (select ( index, item )) (onOpen open)
                                    ]
                                    []
                                , label
                                    [ for (String.fromInt index ++ "_" ++ id)
                                    , Attributes.alt item
                                    , Attributes.title item
                                    , onClick (select ( index, item ))
                                    ]
                                    [ text (toElement ( index, item )) ]
                                ]
                        )
                        data
                    )
                ]
            ]
        ]
