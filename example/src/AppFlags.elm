module AppFlags exposing (AppFlags(..))

import Actors exposing (Actors)
import Framework.Template.Html exposing (HtmlTemplate)


type AppFlags
    = CounterFlags { value: Int, steps: Int }
    | LayoutFlags (HtmlTemplate Actors)
    | EditorFlags String
    | Empty
