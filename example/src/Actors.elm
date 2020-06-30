module Actors exposing (Actors(..), components)

import Framework.Template.Components as Components exposing (Components)
import Framework.Template.Component as Component


type Actors
    = Editor
    | Layout
    | Counter


components : Components Actors
components =
    Components.fromList
        [ Component.make
            { actor = Counter
            , nodeName = "counter-component"
            }
            |> Component.setDefaultAttributes [ ("value", "10") ]
        , Component.make
            { actor = Layout
            , nodeName = "layout-component"
            }
        ]
