module Types exposing (..)

import Browser exposing (UrlRequest)
import Url exposing (Url)


type ToggledDropdown
    = Opened
    | Closed


type DropdownAttributes
    = DropdownAttributes { title : String, open : ToggledDropdown, id : String, value : String, toElement : ( Int, String ) -> String }


type Msg
    = NoOp
    | ToggleDropdown ToggledDropdown
    | ChangeUrl Url
    | ClickLink UrlRequest
    | SelectDropdown ( Int, String )
    | FocusOnDropown
    | FocusOnDropownItem


type alias Model =
    { dropdownState : ToggledDropdown
    , selectedDropdown : ( Maybe Int, Maybe String )
    }
