module Actors exposing (Actors(..), templateComponents)

import Framework.Template.Html as HtmlTemplate exposing (TemplateComponents)


type Actors
    = Editor
    | Layout
    | Counter


templateComponents : TemplateComponents Actors
templateComponents =
    HtmlTemplate.fromList
        [ HtmlTemplate.make
            { actor = Counter
            , nodeName = "counter-component"
            }
            |> HtmlTemplate.setDefaultAttributes [ ("value", "10") ]
        , HtmlTemplate.make
            { actor = Layout
            , nodeName = "layout-component"
            }
        ]
