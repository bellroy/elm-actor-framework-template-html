module Model exposing (Model(..))

import Actors exposing (Actors)
import Components.Counter as Counter
import Components.Editor as Editor
import Components.Layout as Layout


type Model
    = CounterModel Counter.Model
    | EditorModel Editor.Model
    | LayoutModel (Layout.Model Actors)
