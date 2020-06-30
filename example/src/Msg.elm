module Msg exposing (AppMsg(..), Msg)

import Actors exposing (Actors)
import Address exposing (Address(..))
import AppFlags exposing (AppFlags)
import Components.Counter as Counter
import Components.Editor as Editor
import Components.Layout as Layout
import Framework.Message exposing (FrameworkMessage)
import Model exposing (Model)


type AppMsg
    = CounterMsg Counter.MsgIn
    | EditorMsg Editor.MsgIn
    | LayoutMsg (Layout.MsgIn Actors)


type alias Msg =
    FrameworkMessage AppFlags Address Actors Model AppMsg
