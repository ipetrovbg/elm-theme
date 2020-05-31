module Modal exposing (..)

import Core exposing (onEsc)
import Html exposing (Html, button, div, h3, text)
import Html.Attributes exposing (class, id, tabindex)
import Html.Events exposing (onClick)
import Types exposing (ModalAttributes, Msg(..), ToggleState(..))


view : ModalAttributes msg -> (ToggleState -> msg) -> Html msg
view (Types.ModalAttributes { open, backClose, content, titleContent }) close =
    case open of
        Opened ->
            div [ onEsc <| close Closed, tabindex 0 ]
                [ case backClose of
                    True ->
                        div
                            [ class "modal-overlay", onClick <| close Closed ]
                            []

                    False ->
                        div [ class "modal-overlay" ] []
                , div [ class "modal" ]
                    [ div [ class "modal-title" ]
                        [ titleContent ]
                    , div [ class "modal-content" ]
                        [ content
                        ]
                    , div [ class "modal-actions" ]
                        [ button
                            [ id "modal-close"
                            , class "btn modal-close"
                            , onClick <| close Closed
                            ]
                            [ text "Cancel" ]
                        ]
                    ]
                ]

        Closed ->
            text ""
