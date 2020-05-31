module Types exposing (..)

import Browser exposing (UrlRequest)
import Html exposing (Html)
import Url exposing (Url)


type ToggleState
    = Opened
    | Closed


type DropdownAttributes
    = DropdownAttributes { title : String, open : ToggleState, id : String, value : String, toElement : ( Int, String ) -> String }


type Msg
    = NoOp
    | ToggleDropdown ToggleState
    | ChangeUrl Url
    | ClickLink UrlRequest
    | SelectDropdown ( Int, String )
    | FocusOnDropown
    | FocusOn String
    | FocusOnDropownItem
    | FocusOnModal
    | ToggleModal ToggleState


type alias Model =
    { dropdownState : ToggleState
    , selectedDropdown : ( Maybe Int, Maybe String )
    , modalState : ToggleState
    }


type ModalAttributes msg
    = ModalAttributes
        { open : ToggleState
        , titleContent : Html msg
        , backClose : Bool
        , content : Html msg
        }
