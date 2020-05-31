module Main exposing (..)

import Browser exposing (Document)
import Browser.Dom as Dom
import Browser.Events
import Browser.Navigation exposing (Key)
import Dropdown exposing (outsideTarget)
import Html exposing (Html, button, div, h3, text)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Modal
import Task
import Types exposing (DropdownAttributes, ModalAttributes(..), Model, Msg(..), ToggleState(..))
import Update.Extra exposing (andThen)
import Url exposing (Url)


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url navKey =
    ( { dropdownState = Closed
      , selectedDropdown = ( Nothing, Nothing )
      , modalState = Closed
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ChangeUrl url ->
            ( model, Cmd.none )

        ClickLink request ->
            ( model, Cmd.none )

        FocusOnDropown ->
            ( model, Task.attempt (always NoOp) (Dom.focus "dropdown_wrapper") )

        FocusOn id ->
            ( model, Task.attempt (always NoOp) (Dom.focus id) )

        FocusOnModal ->
            ( model, Task.attempt (always NoOp) (Dom.focus "modal-close") )

        FocusOnDropownItem ->
            ( model, Task.attempt (always NoOp) (Dom.focus (String.fromInt (Maybe.withDefault 0 (Tuple.first model.selectedDropdown)) ++ "_dropdown")) )

        SelectDropdown ( checked, item ) ->
            ( { model | selectedDropdown = ( Just checked, Just item ) }, Cmd.none )
                |> andThen update (ToggleDropdown Closed)

        --|> andThen update (FocusOn "modal-close")
        ToggleDropdown Opened ->
            let
                m =
                    case model.dropdownState of
                        Closed ->
                            FocusOnDropownItem

                        Opened ->
                            NoOp
            in
            ( { model | dropdownState = Opened }, Cmd.none )
                |> andThen update m

        ToggleDropdown Closed ->
            ( { model | dropdownState = Closed }, Cmd.none )
                |> andThen update (FocusOn "dropdown_wrapper")

        --|> andThen update FocusOnDropown
        ToggleModal Opened ->
            ( { model | modalState = Opened }, Cmd.none )
                |> andThen update (FocusOn "modal-close")

        ToggleModal Closed ->
            ( { model | modalState = Closed }, Cmd.none )
                |> andThen update (FocusOn "open-modal")


view : Model -> Document Msg
view model =
    { title = "Elm Starter Pack"
    , body =
        --onEsc <| ToggleModal Closed
        [ div [ class "wrapper" ]
            [ div [ class "show-off-wrapper" ]
                [ div [ class "show-off-container" ]
                    [ Dropdown.view
                        (Dropdown.simpleConfig model)
                        Dropdown.simpleDropdownData
                        (\( checked, str ) -> SelectDropdown ( checked, str ))
                        (\opened ->
                            case opened of
                                Closed ->
                                    ToggleDropdown Opened

                                Opened ->
                                    ToggleDropdown Closed
                        )
                    , text (Maybe.withDefault "Nothing is selected yet" (Tuple.second model.selectedDropdown))
                    ]
                ]
            , renderModalButton model.modalState
            , Modal.view
                (ModalAttributes
                    { open = model.modalState
                    , titleContent = h3 [] [ text "Modal title" ]
                    , backClose = True
                    , content =
                        div [ class "content" ]
                            [ text "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." ]
                    }
                )
                (\modalState ->
                    case modalState of
                        Closed ->
                            ToggleModal Closed

                        Opened ->
                            ToggleModal Closed
                )
            ]
        ]
    }


renderModalButton : ToggleState -> Html Msg
renderModalButton modalState =
    button
        [ class "btn"
        , id "open-modal"
        , onClick <|
            case modalState of
                Opened ->
                    ToggleModal Closed

                Closed ->
                    ToggleModal Opened
        ]
        [ text "Open Modal" ]


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions =
            \model ->
                case model.dropdownState of
                    Opened ->
                        Browser.Events.onMouseDown (outsideTarget "dropdown_wrapper")

                    Closed ->
                        Sub.none
        , onUrlRequest = ClickLink
        , onUrlChange = ChangeUrl
        }
