module Main exposing (..)

import Browser exposing (Document)
import Browser.Dom as Dom
import Browser.Events
import Browser.Navigation exposing (Key)
import Dropdown exposing (dropdown, outsideTarget)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Task
import Types exposing (DropdownAttributes, Model, Msg(..), ToggledDropdown(..))
import Update.Extra exposing (andThen)
import Url exposing (Url)


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url navKey =
    ( { dropdownState = Closed
      , selectedDropdown = ( Nothing, Nothing )
      }
    , Cmd.none
    )


data : List String
data =
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

        FocusOnDropownItem ->
            ( model, Task.attempt (always NoOp) (Dom.focus (String.fromInt (Maybe.withDefault 0 (Tuple.first model.selectedDropdown)) ++ "_dropdown")) )

        SelectDropdown ( checked, item ) ->
            ( { model | selectedDropdown = ( Just checked, Just item ) }, Cmd.none )
                |> andThen update (ToggleDropdown Closed)

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
                |> andThen update FocusOnDropown


dropdownConfig : Model -> DropdownAttributes
dropdownConfig model =
    Types.DropdownAttributes
        { title = Maybe.withDefault "Select an Element" (Tuple.second model.selectedDropdown)
        , open = model.dropdownState
        , id = "dropdown"
        , value = Maybe.withDefault "" (Tuple.second model.selectedDropdown)
        , toElement = \( index, element ) -> element
        }


view : Model -> Document Msg
view model =
    { title = "Hello World"
    , body =
        [ div [ class "show-off-wrapper" ]
            [ div [ class "show-off-container" ]
                [ dropdown
                    (dropdownConfig model)
                    data
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
        ]
    }


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
